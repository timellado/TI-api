require 'oc'
require 'logica'
class Filter < ApplicationRecord
  def self.revisar_ftp
    # quizás ordenar por prioridades
    Ordencompra.where(estado: 'creada').each do |order|
      aceptar_ftp(order, 1000 * 60 * 60 * 3)
      order.save
      if order.estado == 'aceptado'
        Logica.mover_productos_a_despacho_y_despachar_distribuidor(order.sku, order.cantidad, order.oc_id)

      end
    end
  end

  def self.aceptar_ftp(order, time)
    inventory = ScheduleStock.inv

    # rechazo si no tengo tiempo de procesar
    puts "TIEMPO -------------"
    puts order.fechaEntrega.to_datetime.to_i
    puts Time.now.to_i
    puts order.fechaEntrega.to_datetime.to_i - Time.now.to_i
    if order.fechaEntrega.to_datetime.to_i - Time.now.to_i > time
      msn = 'Rechazado por poco tiempo'
      puts msn
      Oc.reject_order(order.oc_id, msn)
      order.estado = 'rechazado'
      puts "FECHA ENTREGA"
      puts order.fechaEntrega

    # rechazo si
    elsif inventory.key?(order.sku)
      if inventory[order.sku] < order.cantidad
        msn = 'Rechazado por disponibilidad'
        puts msn
        Oc.reject_order(order.oc_id, msn)
        order.estado = 'rechazado'
      end

    #sino acepto
    else
      Oc.accept_order(order.oc_id)
      puts 'aceptado'
      order.estado = 'aceptado'
  end
end
end

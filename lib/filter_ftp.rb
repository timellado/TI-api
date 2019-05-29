
require 'schedule_stock'
require 'oc'
require 'logica'
module Filter
  include ScheduleStock
  include Oc
  include Logica

  def self.revisar_ftp()

    #quizás ordenar por prioridades
    Ordencompra.where(estado:'creada').each do |order|
      self.aceptar_ftp(order,1000*60*60*3)


      if order.estado == "aceptado"
        Logica.mover_productos_a_despacho_y_despachar_distribuidor(order.sku,order.cantidad,order.oc_id)

      end
    end

  end


  def self.aceptar_ftp(order,time)
    inventory = ScheduleStock.inv

    #rechazo si no tengo tiempo de procesar
    if order.fechaEntrega.to_datetime.to_i - Time.now.to_i < time
      msn = "Rechazado por poco tiempo"
      Oc.reject_order(order.oc_id,msn)
      order.estado = "rechazado"
    end

    #rechazo si
    if inventory.key?(order.sku)
      if inventory[order.sku] < order.cantidad
        msn = "Rechazado por disponibilidad"
        Oc.reject_order(order.oc_id,msn)
        order.estado = "rechazado"
      end
    else 
      Oc.reject_order(order.oc_id,"Rechazado por disponibilidad")
      order.estado = "rechazado"
    end
   

    Oc.accept_order(order.oc_id)
    order.estado = "aceptado"
  end


end

require 'oc'
require 'logica'
require 'stock_minimo'
module Filter 

  def self.revisar_ftp
    # quizás ordenar por prioridades
    dic_inventory = ScheduleStock.inv
    Ordencompra.where(estado: 'cocina').each do |order|
      if dic_inventory.key?(order.sku)

        if dic_inventory[order.sku] >= order.cantidad
          p "se envia a distribuidor"
          Logica.mover_productos_a_despacho_y_despachar_distribuidor(order)

        end

      end
    end
  end

end

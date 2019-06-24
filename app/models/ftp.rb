require 'net/sftp'
require 'httparty'
module Ftp

  def self.get_id
    puts 'it works :D'
    sftp = Net::SFTP.start('fierro.ing.puc.cl', 'grupo10_dev', password: 'kljBJ73njcHGKh1') ## necesitamos dos conexiones
    Net::SFTP.start('fierro.ing.puc.cl', 'grupo10_dev', password: 'kljBJ73njcHGKh1') do |entries|
      entries.dir.foreach('/pedidos/') do |entry|
        if entry.name.include?('xml')
          date_ingreso = entry.name.split('.xml').join
          sftp.file.open('/pedidos' + '/' + entry.name, 'r') do |f|
            content_id = nil
            content_sku = nil
            content_qty = nil
            until f.eof?
              content = f.gets
              # obtengo los ids
              next unless content.include?('id')

              content = content.split('<')[2]
              content = content.split('>')[1]
              content_id = content
              get_oc_data(content_id)
              #se elimina contenido
              sftp.remove!('/pedidos/'+entry.name)
              p content_id
              orden = Ordencompra.where(oc_id: content_id)[0]
              p orden.oc_id
              if aceptar_ftp(orden,60*60)
                p "se manda a cocinar ftp "
                ScheduleStock.cocinar(orden.sku,orden.cantidad)
                orden.estado = "cocina"
                orden.save
              end
              # end if
            end # end while
          end # end if
          end
      end
    end
end

  def  self.save_data(results)
    #  puts "Revisando si se debe guardar en base de datos"
    if Ordencompra.where(oc_id: results['_id']).count == 0
      #   puts "Guardando en la base de datos"
      @orden_compra = Ordencompra.create!(oc_id: results['_id'],
                                          sku: results['sku'].to_s,
                                          cliente: results['cliente'],
                                          fechaEntrega: results['fechaEntrega'],
                                          cantidad: results['cantidad'],
                                          estado: results['estado'])

    end
    end

  def self.get_oc_data(id)
    response = HTTParty.get('https://integracion-2019-dev.herokuapp.com/oc/' + 'obtener/' + id,
                            headers: { 'Content-Type' => 'application/json' })
    #  puts " OC hecha"
    results = JSON.parse(response.to_s)
    if results.any?
      # respuesta no vacia
      results = results[0]
      save_data(results)
    end
  end


    def self.validar_ftp(sku,cantidad)
      dic_inventory = ScheduleStock.inv
      dic_ingredients_product = StockMinimo.get_product_ingredient_dic
      ingredientes =  dic_ingredients_product[sku].keys
      ingredientes.delete('lote')
      ingredientes.delete('tipo')

      dic_ingredients_product[sku].each do |i,j|
        next if i == 'lote'
        next if i == 'tipo'
        if dic_inventory.key?(i)
          if j*cantidad >= dic_inventory[i]
            return false
          end
        else
          return false
        end
        return true
      end
    end

    def self.aceptar_ftp(order, time)
      p "llega a aceptar ftp"
      p order.fechaEntrega
      # rechazo si no tengo tiempo de procesar sacar el +4 cuando este en el servidor
      now = Time.now()
      if order.fechaEntrega.to_datetime.to_i - now.to_i < time
        msn = 'Rechazado por poco tiempo'
        p "se rechaza ftp por tiempo"
        Oc.reject_order(order.oc_id, msn)
        order.estado = 'rechazado'
        order.save
        return false
      end

      if validar_ftp(order.sku,order.cantidad)
          p "se acepta ftp"
        Oc.accept_order(order.oc_id)
        order.estado = 'aceptado'
        order.save
        return true

      else
        msn = 'Rechazado por disponibilidad'
        Oc.reject_order(order.oc_id, msn)
        order.estado = 'rechazado'
        p "se rechaza ftp por disponibilidad"
        order.save
        return false

    end
  end

end

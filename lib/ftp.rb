require 'net/sftp'
require 'httparty'


module FTP

  def self.get_id()
    start = Time.now
    sftp = Net::SFTP.start('fierro.ing.puc.cl', 'grupo10', password: 'xvHAjFqVU8W3fa4h4')  ## necesitamos dos conexiones
    Net::SFTP.start('fierro.ing.puc.cl', 'grupo10', password: 'xvHAjFqVU8W3fa4h4') do |entries|
      entries.dir.foreach('/pedidos10/') do |entry|
        if entry.name.include?("xml")
          date_ingreso = entry.name.split('.xml').join
        	sftp.file.open("/pedidos10" + "/" + entry.name, "r") do |f|
            content_id = nil
            content_sku = nil
            content_qty = nil
            while !f.eof?
              content = f.gets
              # obtengo los ids
              if content.include?("id")
                content = content.split('<')[2]
                content = content.split('>')[1]
                content_id = content
                self.get_oc_data(content_id)
              end #end if
            end #end while
          end #end loop
        end #end if
      end #end loop
    end
    final = Time.now
    puts "Tiempo de FTP.get_id: " + ((final - start)/1.minute).to_s
  end

  def  self.save_data(results)
  #  puts "Revisando si se debe guardar en base de datos"
    if Ordencompra.where(oc_id:results['_id']).count == 0
   #   puts "Guardando en la base de datos"
      @orden_compra = Ordencompra.create!(oc_id: results['_id'],
                                        sku: results['sku'].to_s,
                                        cliente: results['cliente'],
                                        fechaEntrega: results['fechaEntrega'],
                                        cantidad:  results['cantidad'],
                                        estado: results["estado"],
                                        )
    end
  end

    def self.get_oc_data(id)
      response = HTTParty.get("https://integracion-2019-prod.herokuapp.com/oc/"+'obtener/'+id,
      :headers =>{'Content-Type' => 'application/json'})
    #  puts " OC hecha"
      results = JSON.parse(response.to_s)
      results = results[0]
      self.save_data(results)
    end
end

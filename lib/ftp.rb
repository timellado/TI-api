require 'net/sftp'
require 'httparty'

module FTP

  def self.get_id()
  sftp = Net::SFTP.start('fierro.ing.puc.cl', 'grupo10_dev', password: 'kljBJ73njcHGKh1')  ## necesitamos dos conexiones
  Net::SFTP.start('fierro.ing.puc.cl', 'grupo10_dev', password: 'kljBJ73njcHGKh1') do |entries|
        entries.dir.foreach('/pedidos/') do |entry|
          puts entry
          if entry.name.include?("xml")
          		date_ingreso = entry.name.split('.xml').join
          		sftp.file.open("/pedidos" + "/" + entry.name, "r") do |f|
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

              end #end if
            end
          end
        end
      end

    def  self.save_data(results)
      puts "guardando data"
      puts results['_id']
      puts results['_id'].class
      if Ordencompra.where(oc_id:results['_id']).count == 0
        puts "guardando en la bd"
        @orden_compra = Ordencompra.create!(oc_id: results['_id'],
                                          sku: results['sku'].to_s,
                                          cliente: results['cliente'],
                                          fechaEntrega: results['fechaEntrega'],
                                          cantidad:  results['cantidad'],
                                          estado: results["estado"],

                                          )
        puts "ya guardado"
end
end
    def self.get_oc_data(id)
      puts "pedir oc info al profe"
      response = HTTParty.get("https://integracion-2019-dev.herokuapp.com/oc/"+'obtener/'+id,
      :headers =>{'Content-Type' => 'application/json'})
      puts "ya pedida info"
      results = JSON.parse(response.parsed_response)
      puts results
      self.save_data(results)
    end
end

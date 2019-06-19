require 'net/sftp'
require 'httparty'
class Ftp < ApplicationRecord
  def self.get_id
    puts 'it works :D'
    # CAMBIAR CLAVES  y USUARIO A PROD
    sftp = Net::SFTP.start('fierro.ing.puc.cl', 'grupo10_dev', password: 'kljBJ73njcHGKh1') ## necesitamos dos conexiones
    Net::SFTP.start('fierro.ing.puc.cl', 'grupo10_dev', password: 'kljBJ73njcHGKh1') do |entries|
      entries.dir.foreach('/pedidos/') do |entry|    #cambiar a '/pedidos10/' para produccion
        puts "SFTP Recibido"
        if entry.name.include?('xml')
          date_ingreso = entry.name.split('.xml').join
          sftp.file.open('/pedidos' + '/' + entry.name, 'r') do |f| #cambiar a '/pedidos10'
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
              puts content_id
              get_oc_data(content_id)
              # end if
            end # end while
          end # end if
          end
      end
    end
          end

  def  self.save_data(results)
    puts "Revisando si se debe guardar en base de datos"
    puts results
    if Ordencompra.where(oc_id: results['_id']).count == 0
      puts "Guardando en la base de datos"
      @orden_compra = Ordencompra.create!(oc_id: results['_id'],
                                          sku: results['sku'].to_s,
                                          cliente: results['cliente'],
                                          fechaEntrega: results['fechaEntrega'],
                                          cantidad: results['cantidad'],
                                          estado: results['estado'])
    end
    end

  def self.get_oc_data(id)
    puts id
    response = HTTParty.get('https://integracion-2019-dev.herokuapp.com/oc/' + 'obtener/' + id,
                            headers: { 'Content-Type' => 'application/json' })
    puts " OC hecha"
    results = JSON.parse(response.to_s)
    puts results.class()
    if results.any?
      # respuesta no vacia
      results = results[0]
      save_data(results)

    end
  end
end

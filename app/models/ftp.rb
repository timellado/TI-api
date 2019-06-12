require 'net/sftp'
require 'httparty'
class Ftp < ApplicationRecord
  def self.get_id
    puts 'it works :D'
    sftp = Net::SFTP.start('fierro.ing.puc.cl', 'grupo10_dev', password: 'kljBJ73njcHGKh1') ## necesitamos dos conexiones
    Net::SFTP.start('fierro.ing.puc.cl', 'grupo10_dev', password: 'kljBJ73njcHGKh1') do |entries|
      entries.dir.foreach('/pedidos10/') do |entry|
        if entry.name.include?('xml')
          date_ingreso = entry.name.split('.xml').join
          sftp.file.open('/pedidos10' + '/' + entry.name, 'r') do |f|
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
    results = results[0]
    save_data(results)
  end
end

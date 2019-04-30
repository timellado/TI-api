require 'httparty'
require 'hash'
module Bodega
        include Sha1
        $uri = "https://integracion-2019-dev.herokuapp.com/bodega/"

# GETS (Probados)
        #obtiene todos los alamcenes
        def self.all_almacenes()
            sha1 = Sha1.get_sha1('GET')
            response = HTTParty.get($uri+'almacenes',
            :headers =>{'Content-Type' => 'application/json',
            'Authorization'=> 'INTEGRACION grupo10:'+sha1})
            results = response.parsed_response
           # puts results
            return results
         end

         #Obtiene skus con stock en 1 almacen
         def self.get_skus_almacen(almacenid)
            sha1 = Sha1.get_sha1('GET'+almacenid)
            response = HTTParty.get($uri+'skusWithStock?almacenId='+almacenid,
            :headers =>{'Content-Type' => 'application/json',
            'Authorization'=> 'INTEGRACION grupo10:'+sha1})
            results = response.parsed_response
            return results
            #puts results
         end

         #obtener productos no vencidos en unn almacen para 1 sku
         def self.get_Prod_almacen_sku(almacenid, sku)
            sha1 = Sha1.get_sha1('GET'+almacenid+sku)
            response = HTTParty.get($uri+'stock?almacenId='+almacenid+'&sku='+sku,
            :headers =>{'Content-Type' => 'application/json',
            'Authorization'=> 'INTEGRACION grupo10:'+sha1})
            results = response.parsed_response
            return results
            #puts results
         end
#MOVER (Probar)
         #Mover Producto a otra bodega (despacho a otro grupo)
         def self.Mover_bodega(almacenid, productid)
            sha1 = Sha1.get_sha1('POST'+productid+almacenid)
            response = HTTParty.post($uri+'moveStockBodega',
            :headers =>{'Content-Type' => 'application/json',
            'Authorization'=> 'INTEGRACION grupo10:'+sha1},
            :body => {'productoId'=>productid, 'almacenId'=> almacenid,'precio'=> "1"}.to_json)
            results = response.parsed_response
            #puts results
         end

         #Mover Producto a otro almacen propio
         def self.Mover_almacen(almacenid, productid)
            sha1 = Sha1.get_sha1('POST'+productid+almacenid)
            #puts sha1
            response = HTTParty.post($uri+'moveStock',
            :headers =>{'Content-Type' => 'application/json', 
            'Authorization'=> 'INTEGRACION grupo10:'+sha1},
            :body => {'productoId'=> productid, 'almacenId'=> almacenid}.to_json)
            results = response.parsed_response
            return results
            #puts results
         end
#Fabricar(Probar)
        def self.Fabricar_gratis(sku, cantidad)
            sha1 = Sha1.get_sha1('PUT'+sku+cantidad.to_s)
         #   puts sha1
            response = HTTParty.put($uri+'fabrica/fabricarSinPago',
            :headers =>{'Content-Type' => 'application/json',
            'Authorization'=> 'INTEGRACION grupo10:'+sha1},
            :body => {'sku' => sku, 'cantidad' => cantidad}.to_json)
            results = response.parsed_response
            #puts cantidad
          
            puts results
            return results

        end

#Pedir a otro grupo(Probar)
        def self.Pedir(sku, cantidad, grupo)
        #puts grupo
          if grupo != 10
            #cambiar en produccion
            almacenid = "5cbd3ce444f67600049431e9"
            url = 'http://tuerca'+grupo.to_s+'.ing.puc.cl/'
            
            begin
                response = HTTParty.post(url+'orders',
                        :headers =>{'group' => '10'},
                        :body =>{
                            'sku' => sku,
                            'cantidad' => cantidad,
                            'almacenId' =>almacenid
                        })
                status = response.code
                #puts status
                if status == 200
                        results = response.parsed_response  
                       #puts "respondio"  
                        #puts results
                        return results
                
                else
                        return 
                end
                
            rescue 
                
                return 
                    
            end
            
            #puts results
          end
        end


end

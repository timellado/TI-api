require 'httparty'
require 'hash'
require 'variable'

module Bodega
        include Sha1
        include Variable
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

         def self.Eliminar_producto(productid)
               
                sha1 = Sha1.get_sha1('DELETE'+productid+'hola'+'1001'+'4af9f23d8ead0e1d32000900')
                #puts sha
                response = HTTParty.delete($uri+'stock',
                :headers =>{'Content-Type' => 'application/json',
                'Authorization'=> 'INTEGRACION grupo10:'+sha1},
                :body => {'productoId'=> productid, 'direccion'=>'hola','oc'=> '4af9f23d8ead0e1d32000900',
                        'precio' => 1001
                }.to_json)
                results = response.parsed_response
                puts results
                return results
                #puts results
         end

         def self.Eliminar_todos()
                puts "eliminar todos"
                almacenes = [Variable.v_recepcion,Variable.v_cocina,Variable.v_despacho,Variable.v_pulmon,
                Variable.v_inventario1, Variable.v_inventario2]
                almacenes.each do |almacen|
                #skus de un almacen
                        skus= self.get_skus_almacen(almacen)
                        if skus.length >0
                                skus.each do |sku|
                                        products = self.get_Prod_almacen_sku(almacen,sku["_id"])
                                        if products.length>0
                                                products.each do |product|
                                                        if almacen = Variable.v_inventario1
                                                                self.Mover_almacen(Variable.v_despacho,product["_id"])
                                                                self.Eliminar_producto(product["_id"])
                                                        
                                                        elsif almacen == Variable.v_pulmon
                                                                self.Mover_almacen(Variable.v_recepcion,product["_id"])
                                                                self.Mover_almacen(Variable.v_despacho,product["_id"])
                                                                self.Eliminar_producto(product["_id"])
                                                        end
                                                end 
                                        end
                                end 
                        end 

                end
                puts "termina de eliminar"

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
            puts "Fabricar gratis"
            puts results
            if response.code == 200
                return results
            end
            return nil
        end

#Pedir a otro grupo(Probar)
        def self.Pedir(sku, cantidad, grupo)
        puts "Pidiendo sku & cantidad: ", sku, cantidad
          if grupo != 10
            #cambiar en produccion
            almacenid = Variable.v_recepcion
            url = 'http://tuerca'+grupo.to_s+'.ing.puc.cl/'

            begin
                response = HTTParty.post(url+'orders',
                        :headers =>{'group' => '10', 'Content-Type' => 'application/json'},
                        :body =>{
                            'sku' => sku,
                            'cantidad' => cantidad,
                            'almacenId' =>almacenid
                        })
                status = response.code
                puts "Pedir grupo",grupo,status

                if status == 200 || status == 201
                        results = response.parsed_response
                       #puts "respondio"
                        puts results
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

        def self.get_inventory_group(grupo)
                dic = {}
                url = 'http://tuerca'+grupo.to_s+'.ing.puc.cl/'

                begin
                        response = HTTParty.get(url+'inventories')
                        status = response.code
                        puts "Pedir inventories grupo: "+ grupo.to_s, " Status: " + status.to_s
        
                        if status == 200 || status == 201
                                results = response.parsed_response
                               #puts "respondio"
                                results.each do |a|
                                        dic[a["sku"]] = a["total"]
                                end
                                puts dic
                                return dic        
                        else
                                return
                        end
                rescue
                        return
                end
        end




end



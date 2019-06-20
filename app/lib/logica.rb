require 'inventory'
require 'stock_minimo'
require 'bodega'
require 'almacen'
require 'variable'
module Logica
include Inventory
include StockMinimo
include Bodega
include Almacen
include Variable

## esta función retorna true siesque el pedido de otro grupo lo podemos
## enviar y false en el caso contrario

    def self.sku_disponible(sku, cantidad_pedida)
        lista_sku = Inventory.get_inventory_for_group()
        got_sku = false
        stock = 0
        lista_sku.each do |js|
            if js["sku"] == sku
                    got_sku = true
                    stock = js["total"]
            end
        end
        return got_sku
    end

## Función que valida si lo pedido por otro grupo menos el stock que tenemos es mayor
## que el stock min que debemos soportar

    def self.validar_stock(sku, cantidad, stock)
        lista_skus_min = StockMinimo.get_minimum_stock()
        lista_skus_min.each do |li|
            if li[0] == sku
                ## esto representa que si el stock que tenemos menos lo que nos piden es mayor
                ## que el stock min entonces se puede hacer la transacción
                if li[1] > stock-cantidad
                    return false
                end

                return true

              end
      return false
    end

  end

    def self.listar_sku_id(sku)
        lista_id = []
        ## Revisar almacenes
        lista_id.concat (self.listar_no_vencidos(Variable.v_recepcion,sku))
        lista_id.concat (self.listar_no_vencidos(Variable.v_inventario1,sku))
        lista_id.concat (self.listar_no_vencidos(Variable.v_inventario2,sku))
        lista_id.concat (self.listar_no_vencidos(Variable.v_pulmon,sku))
        lista_id.concat (self.listar_no_vencidos(Variable.v_cocina,sku))
        lista_id = lista_id.sort{ |a,b| a[1]<=> b[1]}
        return lista_id
    end

    def self.listar_sku_id_despacho(sku)
        lista_id = []
        ## Revisar almacenes
        lista_id.concat (self.listar_no_vencidos(Variable.v_despacho,sku))
        lista_id = lista_id.sort{ |a,b| a[1]<=> b[1]}
        return lista_id
    end

    ##
    def self.listar_no_vencidos(almacen_id,sku)
        lista_id = []

        ## Revisar recepción
        jsn = JSON.parse(Bodega.get_Prod_almacen_sku(almacen_id, sku).to_json)
        jsn.each do |j|
            lista_id.append [j["_id"],j["vencimiento"]]
        end
        lista_id = lista_id.sort{ |a,b| a[1]<=> b[1]}
        return lista_id
    end

    def self.clean_reception
        almacenes = Bodega.all_almacenes()
        vaciar = false
        space_i1 = contar_espacio_libre(Variable.v_inventario1)
        space_i2 = contar_espacio_libre(Variable.v_inventario2)

        if contar_espacio_usado(Variable.v_recepcion) >0
          vaciar = true
        end

        if vaciar
          #todos los sku del alamcen de recepcion
          skus = Bodega.get_skus_almacen(Variable.v_recepcion)
          #puts skus
          skus.each do |s|
            #se ve el sku cada uno
            sku = s['_id']
            products = Bodega.get_Prod_almacen_sku(Variable.v_recepcion, sku)
            #se obtienen los productos
            products.each do |product|
              product_id = product['_id']
              #si el 1 tiene espacio se mueve
              if space_i1 >0
                Bodega.Mover_almacen(Variable.v_inventario1 , product_id)
              #si el 1 no tiene y el 2 si, se va al 2
              elsif space_i2 >0
                Bodega.Mover_almacen(Variable.v_inventario2 , product_id)
              end

            end
          end
         # puts 'vacio'

        end
    end

    def self.clean_pulmon
      almacenes = Bodega.all_almacenes()
      vaciar = false
      space_i1 = contar_espacio_libre(Variable.v_inventario1)
      space_i2 = contar_espacio_libre(Variable.v_inventario2)
      space_recepcion = contar_espacio_libre(Variable.v_recepcion)

      if contar_espacio_usado(Variable.v_pulmon) >0
        vaciar = true
      end
      

      if vaciar
        #todos los sku del alamcen de recepcion
        skus = Bodega.get_skus_almacen(Variable.v_pulmon)
        #puts skus
        skus.each do |s|
          #se ve el sku cada uno
          sku = s['_id']
          products = Bodega.get_Prod_almacen_sku(Variable.v_pulmon, sku)
          #se obtienen los productos
          products.each do |product|
            product_id = product['_id']
            #si el 1 tiene espacio se mueve
            if space_i1 >0
              Bodega.Mover_almacen(Variable.v_inventario1 , product_id)
            #si el 1 no tiene y el 2 si, se va al 2
            elsif space_i2 >0
              Bodega.Mover_almacen(Variable.v_inventario2 , product_id)
            elsif space_recepcion>0
              Bodega.Mover_almacen(Variable.v_recepcion , product_id)
            end

          end
        end
       # puts 'vacio'

      end
  end

    def self.mover_productos_a_despacho_y_despachar(sku,cantidad,almacen_destino, oc)
      lista_id_sku_recepcion = self.listar_no_vencidos(Variable.v_recepcion,sku)
      lista_id_sku_i1 = self.listar_no_vencidos(Variable.v_inventario1,sku)
      lista_id_sku_i2 = self.listar_no_vencidos(Variable.v_inventario2,sku)
      lista_id_sku_pulmon = self.listar_no_vencidos(Variable.v_pulmon,sku)

        cont = 0

        (0..lista_id_sku_recepcion.length-1).each do |i|
            if cont >= cantidad
              break
            end
            p "moviendo SKU: "+sku.to_s+" desde recepcion, ID: "+lista_id_sku_recepcion[i][0].to_s
            Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_recepcion[i][0])
            Bodega.Mover_bodega(sku, almacen_destino,lista_id_sku_recepcion[i][0], oc)
            p "se movio" 
            cont = cont + 1

        end

        (0..lista_id_sku_i1.length-1).each do |i|
          if cont >= cantidad
            break
          end
          p "moviendo SKU: "+sku.to_s+" desde Inv 1, ID: "+lista_id_sku_i1[i][0].to_s
            Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_i1[i][0])
            Bodega.Mover_bodega(sku, almacen_destino,lista_id_sku_i1[i][0], oc)
          p "se movio"
            cont = cont + 1

        end

        (0..lista_id_sku_i2.length-1).each do |i|
          if cont >= cantidad
            break
          end
          p "moviendo SKU: "+sku.to_s+" desde Inv 1, ID: "+lista_id_sku_i2[i][0].to_s
            Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_i2[i][0])
            Bodega.Mover_bodega(sku, almacen_destino,lista_id_sku_i2[i][0], oc)
            p "se movio"
            cont = cont + 1

        end

        espacio_libre_rec = self.contar_espacio_libre(Variable.v_recepcion)

   
          (0..lista_id_sku_pulmon.length-1).each do |i|
            if cont >= cantidad
              break
            end
            product_id = lista_id_sku_pulmon[i][0]
            p "moviendo SKU: "+sku.to_s+" desde pulmón, ID: "+product_id.to_s
            Bodega.Mover_almacen(Variable.v_despacho,product_id)
            Bodega.Mover_bodega(sku, almacen_destino,product_id, oc)
            p "se movio"
            cont = cont +1

          end
    end

    def self.despachar_a_grupo(sku,cantidad,almacen_destino, oc)
        lista_id = listar_sku_id_despacho(sku)
        (0..cantidad-1).each do |d| 
           Bodega.Mover_almacen(Variable.v_despacho,lista_id[d][0])
           Bodega.Mover_bodega(sku, almacen_destino,lista_id[d][0], oc)
        end
    end

    def self.validar_productores_materia_prima(sku)
      Group.find_by_grupo(10).products.each do |product|
        if sku == product.sku
          return true
        end
      end
      return false
    end

    def self.validar_envio_materia_prima(sku,cantidad)
      if self.validar_productores_materia_prima(sku) == true
        lista_sku = Inventory.get_inventory_for_group()
        stock = 0
          lista_sku.each do |js|
              if js["sku"] == sku
                    stock = js["total"]
              end
          end

            diff = stock - cantidad
          if diff < 0
            return false
          end

        return true
      end
    end

    def self.mover_a_despacho_para_minimo(sku, cantidad)
    #  puts "Mover: "+cantidad.to_s+" de "+sku.to_s+" a despacho"

      lista_sku = self.inv_dic()
      stock = lista_sku[sku]

      if stock >= cantidad
        lista_sku_recepcion = self.listar_no_vencidos(Variable.v_recepcion,sku)
        lista_sku_i1 = self.listar_no_vencidos(Variable.v_inventario1,sku)
        lista_sku_i2 = self.listar_no_vencidos(Variable.v_inventario2,sku)
        lista_sku_pulmon = self.listar_no_vencidos(Variable.v_pulmon,sku)

        cont = 0

        (0..lista_sku_recepcion.length-1).each do |i|
          if cont >= cantidad
            return true
          end
          Bodega.Mover_almacen(Variable.v_despacho,lista_sku_recepcion[i][0])
          cont = cont + 1
        end

        (0..lista_sku_i1.length-1).each do |i|
          if cont >= cantidad
            return true
          end
          Bodega.Mover_almacen(Variable.v_despacho,lista_sku_i1[i][0])
          cont = cont + 1
        end

        (0..lista_sku_i2.length-1).each do |i|
          if cont >= cantidad
            return true
          end
          Bodega.Mover_almacen(Variable.v_despacho,lista_sku_i2[i][0])
          cont = cont + 1
        end

        (0..lista_sku_pulmon.length-1).each do |i|
          if cont >= cantidad
            return true
          end
          product_id = lista_sku_pulmon[i][0]
          Bodega.Mover_almacen(Variable.v_despacho,product_id)
          cont = cont +1
        end
        return true
      else
        return false
      end
    end
    
    def self.sacar_de_despacho(sku, cantidad)
      almacenes = Bodega.all_almacenes()
      space_i1 = 0
      space_i2 = 0
      almacenes.each do |almacen|
        if almacen['_id'] == Variable.v_inventario1
          space_i1 = almacen['totalSpace'] - almacen['usedSpace']
        end
        if almacen['_id'] == Variable.v_inventario2
          space_i2 = almacen['totalSpace'] - almacen['usedSpace']
        end
      end
      products = Bodega.get_Prod_almacen_sku(Variable.v_despacho, sku)
      count = 0
      #se obtienen los productos
      products.each do |product|
        if count <= cantidad
          product_id = product['_id']
          #si el 1 tiene espacio se mueve
          if space_i1 >0
            Bodega.Mover_almacen(Variable.v_inventario1 , product_id)
            count += 1
          #si el 1 no tiene y el 2 si, se va al 2
          elsif space_i2 >0
            Bodega.Mover_almacen(Variable.v_inventario2 , product_id)
            count += 1
          end
        else
          break
        end
      end
    end

    def self.tengo_stock(sku, cantidad)
      lista_sku = Inventory.get_inventory()
      got_sku = false
      stock = 0
      lista_sku.each do |js|
        if js["sku"] == sku
          got_sku = true
          stock += js["total"]
        end
      end
      if stock >= cantidad
        return true
      end
      return false
    end

    def self.clean_despacho
      self.clean_reception
      despacho = Variable.v_despacho()
      recepcion = Variable.v_recepcion()
      @resul_despacho = JSON.parse(Bodega.get_skus_almacen(despacho).to_json)
      @resul_despacho.each do |d|
       # puts '########################'+d["_id"]+'####################################'
        lista_id_no_vencidos = listar_no_vencidos(despacho,d["_id"])
        lista_id_no_vencidos.each do |r|
          Bodega.Mover_almacen(recepcion, r[0])
        end
      end
    end
    
    def self.clean_cocina
      self.clean_reception
      cocina = Variable.v_cocina()
      recepcion = Variable.v_recepcion()
      @resul_cocina = JSON.parse(Bodega.get_skus_almacen(cocina).to_json)
      @resul_cocina.each do |d|
       # puts '########################'+d["_id"]+'####################################'
        lista_id_no_vencidos = listar_no_vencidos(cocina,d["_id"])
        lista_id_no_vencidos.each do |r|
          Bodega.Mover_almacen(recepcion, r[0])
        end
      end
    end

    def self.mover_a_cocina(sku,cantidad)
      producto = Product.find_by_sku(sku)
      ingredientes = producto.ingredients
      factor = (cantidad / producto.lote_produccion).ceil
      schedule = false
      movidos = true
      total_ingredientes = ingredientes.count
      ingredientes_a_mover = []

      (0..factor-1).each do |fac|
        contador_espacio = 0
        ingredientes.each do |i|
          q_ingredient = ((i.unidades_bodega).ceil).to_i
          #p "Moviendo a despacho: ", i.sku
          if tengo_stock(i.sku, q_ingredient)
            #Logica.mover_a_despacho_para_minimo(i.sku, q_ingredient)
            ingredientes_a_mover.push([i.sku, q_ingredient])
            contador_espacio += q_ingredient
          end
        end
        if ingredientes_a_mover.count == total_ingredientes
          #p "Fabricar producto: ", sku
          if revisar_espacio_cocina(contador_espacio)
            ingredientes_a_mover.each do |i|
              Logica.mover_a_cocina_para_minimo(i[0], i[1])
            end
          end
          Bodega.Fabricar_gratis(sku, cantidad)
        end
      end
    end

    def self.revisar_espacio_cocina(cantidad)
      espacio_libre_cocina =  self.contar_espacio_libre(Variable.v_cocina)
      if espacio_libre_cocina-2 > cantidad
        return true
      end
      return false    
    end

    def self.mover_a_cocina_para_minimo(sku, cantidad)
      
      lista_sku = self.inv_dic()
      stock = lista_sku[sku]
      
      if stock >= cantidad
        lista_sku_recepcion = self.listar_no_vencidos(Variable.v_recepcion,sku)
        lista_sku_i1 = self.listar_no_vencidos(Variable.v_inventario1,sku)
        lista_sku_i2 = self.listar_no_vencidos(Variable.v_inventario2,sku)
        lista_sku_pulmon = self.listar_no_vencidos(Variable.v_pulmon,sku)

        cont = 0

        (0..lista_sku_recepcion.length-1).each do |i|
          if cont >= cantidad
            return true
          end
          Bodega.Mover_almacen(Variable.v_cocina,lista_sku_recepcion[i][0])
          cont = cont + 1
        end

        (0..lista_sku_i1.length-1).each do |i|
          if cont >= cantidad
            return true
          end
          Bodega.Mover_almacen(Variable.v_cocina,lista_sku_i1[i][0])
          cont = cont + 1
        end

        (0..lista_sku_i2.length-1).each do |i|
          if cont >= cantidad
            return true
          end
          Bodega.Mover_almacen(Variable.v_cocina,lista_sku_i2[i][0])
          cont = cont + 1
        end

        (0..lista_sku_pulmon.length-1).each do |i|
          if cont >= cantidad
            return true
          end
          product_id = lista_sku_pulmon[i][0]
          Bodega.Mover_almacen(Variable.v_cocina,product_id)
          cont = cont +1
        end
        
        return true
      else
        return false
      end
    end

    def self.mover_productos_a_despacho_y_despachar_distribuidor(sku,cantidad,oc)
      lista_id_sku_recepcion = self.listar_no_vencidos(Variable.v_recepcion,sku)
      lista_id_sku_i1 = self.listar_no_vencidos(Variable.v_inventario1,sku)
      lista_id_sku_i2 = self.listar_no_vencidos(Variable.v_inventario2,sku)
      lista_id_sku_pulmon = self.listar_no_vencidos(Variable.v_pulmon,sku)

        cont = 0

        (0..lista_id_sku_recepcion.length-1).each do |i|
            if cont >= cantidad
              break
            end

            Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_recepcion[i][0])
            Bodega.Mover_distribuidor(lista_id_sku_recepcion[i][0],oc)
            cont = cont + 1

        end

        (0..lista_id_sku_i1.length-1).each do |i|
          if cont >= cantidad
            break
          end

            Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_i1[i][0])
            Bodega.Mover_distribuidor(lista_id_sku_i1[i][0],oc)
            cont = cont + 1

        end

        (0..lista_id_sku_i2.length-1).each do |i|
          if cont >= cantidad
            break
          end

            Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_i2[i][0])
            Bodega.Mover_distribuidor(lista_id_sku_i2[i][0],oc)
            cont = cont + 1

        end
 
          (0..lista_id_sku_pulmon.length-1).each do |i|
            if cont >= cantidad
              break
            end
            product_id = lista_id_sku_pulmon[i][0]
            Bodega.Mover_almacen(Variable.v_despacho,product_id)
            Bodega.Mover_distribuidor(product_id,oc)
            cont = cont +1

          end
        
    end

    def self.contar_espacio_libre(almacenid)
      skus = Bodega.get_skus_almacen(almacenid)
      almacenes = Bodega.all_almacenes
      espacio_bodega = nil
      espacio_usado = 0
      almacenes.each do |it|
        if it["_id"] == almacenid
          espacio_bodega = it["totalSpace"]
        end
      end
      skus.each do |i|
        espacio_usado += i['total']
      end
      #p espacio_bodega
      #p espacio_usado
      resta = espacio_bodega-espacio_usado
      return resta
    end

    def self.contar_espacio_usado(almacenid)
      skus = Bodega.get_skus_almacen(almacenid)
      espacio_usado = 0
      skus.each do |i|
        espacio_usado += i['total']
      end
      return espacio_usado
    end

    def self.inv_dic
      dic = {}
      invent = Inventory.get_inventory()
      invent.each do |a|
        dic[a["sku"]] = a["total"]
      end
      return dic
    end


end

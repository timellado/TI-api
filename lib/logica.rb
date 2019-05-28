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
        return got_sku && self.validar_stock(sku, cantidad_pedida, stock)
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
        recepcion_id = ''
        vaciar = false
        space_i1 = 0
        space_i2 = 0

        almacenes.each do |almacen|
          if almacen['recepcion'] == true
            recepcion_id = almacen['_id']
            if almacen['usedSpace'] >0
              vaciar = true
            end
          end
          if almacen['_id'] == Variable.v_inventario1
            space_i1 = almacen['totalSpace'] - almacen['usedSpace']

          end
          if almacen['_id'] == Variable.v_inventario2
            space_i2 = almacen['totalSpace'] - almacen['usedSpace']

          end
        end

        if vaciar
          #todos los sku del alamcen de recepcion
          skus = Bodega.get_skus_almacen(recepcion_id)
          #puts skus
          skus.each do |s|
            #se ve el sku cada uno
            sku = s['_id']
            products = Bodega.get_Prod_almacen_sku(recepcion_id, sku)
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
          puts 'vacio'

        end
    end


    def self.mover_productos_a_despacho_y_despachar(sku,cantidad,almacen_destino)
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
            Bodega.Mover_bodega(almacen_destino,lista_id_sku_recepcion[i][0])
            cont = cont + 1

        end

        (0..lista_id_sku_i1.length-1).each do |i|
          if cont >= cantidad
            break
          end

            Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_i1[i][0])
            Bodega.Mover_bodega(almacen_destino,lista_id_sku_i1[i][0])
            cont = cont + 1

        end

        (0..lista_id_sku_i2.length-1).each do |i|
          if cont >= cantidad
            break
          end

            Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_i2[i][0])
            Bodega.Mover_bodega(almacen_destino,lista_id_sku_i2[i][0])
            cont = cont + 1

        end

        self.clean_reception

        while cont < cantidad do

          (0..lista_id_sku_pulmon.length-1).each do |i|
            product_id = lista_id_sku_pulmon[i][0]
            Bodega.Mover_almacen(Variable.v_recepcion,lista_id_sku_pulmon[i][0])
            Bodega.Mover_almacen(Variable.v_despacho,product_id)
            Bodega.Mover_bodega(almacen_destino,product_id)
            cont = cont +1

          end
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

        self.clean_reception

        while cont < cantidad do

          (0..lista_id_sku_pulmon.length-1).each do |i|
            product_id = lista_id_sku_pulmon[i][0]
            Bodega.Mover_almacen(Variable.v_recepcion,lista_id_sku_pulmon[i][0])
            Bodega.Mover_almacen(Variable.v_despacho,product_id)
            Bodega.Mover_distribuidor(product_id,oc)
            cont = cont +1

          end
        end
    end

    def self.despachar_a_grupo(sku,cantidad,almacen_destino)
        lista_id = listar_sku_id_despacho(sku)
        (0..cantidad-1).each{
           |d| Bodega.Mover_bodega(almacen_destino,lista_id[d][0])
        }

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
        lista_sku = Inventory.get_inventory()
        stock = 0
          lista_sku.each do |js|
              if js["sku"] == sku
                    stock = js["total"]
              end
          end

            diff = stock - cantidad
          if diff < (1/3*stock)
            return false
          end

        return true
      end
    end

    def self.mover_a_despacho_para_minimo(sku, cantidad)
      lista_sku = Inventory.get_inventory()
      got_sku = false
      stock = 0
      lista_sku.each do |js|
        if js["sku"] == sku
          got_sku = true
          stock = js["total"]
        end
      end
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

        self.clean_reception

        while cont < cantidad do

          (0..lista_sku_pulmon.length-1).each do |i|
            product_id = lista_sku_pulmon[i][0]
            Bodega.Mover_almacen(Variable.v_recepcion,lista_sku_pulmon[i][0])
            Bodega.Mover_almacen(Variable.v_despacho,product_id)
            cont = cont +1
          end
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
          stock = js["total"]
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
      almacenes = JSON.parse(Bodega.all_almacenes().to_json)
      almacenes.each do |it|
        if it["_id"] == cocina_id
          usedS = it["usedSpace"]
          totalS = it["totalSpace"]
        end
      end

      if totalS.to_i-usedS.to_i-2 > cantidad
        return true
      end
      return false
    end

    def self.mover_a_cocina_para_minimo(sku, cantidad)
      lista_sku = Inventory.get_inventory()
      got_sku = false
      stock = 0
      lista_sku.each do |js|
        if js["sku"] == sku
          got_sku = true
          stock = js["total"]
        end
      end
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

        self.clean_reception

        while cont < cantidad do
          (0..lista_sku_pulmon.length-1).each do |i|
            product_id = lista_sku_pulmon[i][0]
            Bodega.Mover_almacen(Variable.v_recepcion,lista_sku_pulmon[i][0])
            Bodega.Mover_almacen(Variable.v_cocina,product_id)
            cont = cont +1
          end
        end
        return true
      else
        return false
      end
    end

end

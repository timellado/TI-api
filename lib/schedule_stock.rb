require 'inventory'
require 'stock_minimo'
require 'logica'
require 'variable'
require_relative "../config/environment.rb"

module ScheduleStock
  include Inventory
  include StockMinimo
  include Logica
  include Variable

  def self.keep_minimum_stock
    ## entrega una lista de listas donde muestra el producto con su min stock
    minimum_stock_list = StockMinimo.get_minimum_stock
    ## entrega una lista de lista donde muestra sku,nombre y cantidad
    stock = Inventory.get_inventory
    #puts minimum_stock_list
    #puts current_products
    stock_a_pedir = {}

    minimum_stock_list.each do |mins|
      sku_a_pedir = mins[0].to_s
      minimo = mins[1].to_f
      stock.each do |d|
        if d['sku'] == sku_a_pedir
          minimo -= d['total']
          if minimo <0
            minimo=0
          end
        end
      end
      ## cachar bien cuanto queremos pedir
      minimo = (minimo * 1.3).to_f
      ## -----------------------------------
      producto = Product.find_by_sku(sku_a_pedir)
      factor =  (minimo / producto.lote_produccion).ceil
      ## cuanto debemos pedir nosotros para que nosotros estemos bien
      cantidad_a_pedir = producto.lote_produccion * factor
      if stock_a_pedir.key?(sku_a_pedir)
         stock_a_pedir[sku_a_pedir] += cantidad_a_pedir
      else
        stock_a_pedir[sku_a_pedir] = cantidad_a_pedir
      end
      ## se agregan al diccionario los ingredientes (PROBAR)
      self.add_ingredientes(sku_a_pedir,minimo,stock_a_pedir)
      
    end
    puts '------------------------revisar diccionario start--------------------------------------'
    puts stock_a_pedir
    puts '------------------------revisar diccionario fin--------------------------------------'
    stock_a_pedir.each do |sku, cantidad|
      #p ("SKU" : sku)
      #p ("Q": cantidad)

        producto = Product.find_by_sku(sku)
        factor =  (cantidad / producto.lote_produccion).ceil
        cantidad_a_pedir = (producto.lote_produccion * factor).to_i
        stock.each do |s|
          if s['sku'] == sku
            cantidad -= s['total']
            factor =  (cantidad / producto.lote_produccion).ceil
            cantidad_a_pedir = (producto.lote_produccion * factor).to_i

          end
        end
        if cantidad_a_pedir>0
          self.pedir_producto(sku, cantidad_a_pedir)
        end

    end
  end

  def add_ingredientes(sku,cantidad,stock_a_pedir)
    product = Product.find_by_sku(sku)
    factor =  (cantidad / product.lote_produccion).ceil
    ingredientes = product.ingredients
    if ingredientes.length >0
      ingredientes.each do |i|
        
        if stock_a_pedir.key?(i.sku.to_s)
           stock_a_pedir[i.sku.to_s] += i.unidades_bodega * factor
        else
          stock_a_pedir[i.sku.to_s] = i.unidades_bodega * factor
        end
        add_ingredientes(i.sku.to_s,stock_a_pedir[i.sku.to_s],stock_a_pedir)
      end
    else
      return
    end
  end




  def self.pedir_producto(sku, cantidad)
    despacho_id = Variable.v_despacho
    almacenes = JSON.parse(Bodega.all_almacenes().to_json)
    totalS = nil
    usedS = nil
    almacenes.each do |it|
      if it["_id"] == despacho_id
        usedS = it["usedSpace"]
        totalS = it["totalSpace"]
      end
    end
    producto = Product.find_by_sku(sku)
    #Pedir a otros grupos
    groups = producto.groups
    vacio = false
    #groups_id = groups.map{|m| m.id()}
    ##puts '------------------------revisar groups_id start--------------------------------------'
    ##puts sku,cantidad
    ##puts '------------------------revisar groups_id fin--------------------------------------'
##
    ##puts '------------------------revisar groups start--------------------------------------'
    ##puts groups
    ##puts '------------------------revisar groups fin--------------------------------------'


    futuro_envio = false
    pedidos = []
    #p "Pedir a grupos"
    if groups.length == 0
      puts "vacio"
      vacio = true
      groups = [1,2,3,4,5,6,7,8,9,11,12,13,14]
    end

      groups.each do |g|
        #p ("SKU :", sku)
        #p ("Q :", cantidad)
        #p ("Grupo :", g)
        #p "*" * 10
        if vacio
          pedido = JSON.parse(Bodega.Pedir(sku.to_s, 5, g.to_s).to_json)
        else
          pedido = JSON.parse(Bodega.Pedir(sku.to_s, 5, g.grupo.to_s).to_json)
        end


        ## está raro esta forma de analisar siesque se aceptó el pedido o no (no deberia ser con codes?)
        if pedido.nil? == false
          #puts pedido
          pedidos.push(pedido)
        end
      end
      if pedidos.length >0
        pedidos.each do |ped|
          if ped["aceptado"] == true
            futuro_envio = true
          end
        end
      end
      if futuro_envio == false
        #Pedir en bodega
        puts "bodega"
        if sku > "1016"
          ingredientes = producto.ingredients
          factor = (cantidad / producto.lote_produccion).ceil
          schedule = false
          movidos = true
          total_ingredientes = ingredientes.count
          #if sku == '1111'
          #  puts '##############################################################################################'
          #  puts 'ingredientes:'+ingredientes
          #  puts 'factor:'+factor
          #  puts 'total_ingredientes:'+tota_ingredientes
          #  puts 'cantidad:'+cantidad
          #  puts '##############################################################################################'
#
          #end
          ingredientes_a_mover = []
          contador_espacio = 0

          ingredientes.each do |i|
            q_ingredient = ((i.unidades_bodega * factor).ceil).to_i
            #p "Moviendo a despacho: ", i.sku
            if Logica.puedo_mover_a_despacho(i.sku, q_ingredient)
              #Logica.mover_a_despacho_para_minimo(i.sku, q_ingredient)
              ingredientes_a_mover.push([i.sku, q_ingredient])
              contador_espacio += q_ingredient
            end
          end
          if ingredientes_a_mover.count == total_ingredientes
            #p "Fabricar producto: ", sku
            if totalS.to_i-usedS.to_i >= contador_espacio
              ingredientes_a_mover.each do |i|
                Logica.mover_a_despacho_para_minimo(i[0], i[1])
              end
            end
            Bodega.Fabricar_gratis(sku, cantidad)
          end
        else
          if sku == "1001" || sku == "1004" || sku == "1011" || sku == "1013" || sku == "1016"
            #p "Fabricar materia prima: ", sku
            Bodega.Fabricar_gratis(sku, cantidad)
          end
        end
      end

  end

  def self.clean
    Logica.clean_reception()
  end
end
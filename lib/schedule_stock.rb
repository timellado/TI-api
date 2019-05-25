require 'inventory'
require 'stock_minimo'
require 'logica'
require 'variable'
require_relative "../config/environment.rb"
require 'date'

module ScheduleStock
  include Inventory
  include StockMinimo
  include Logica
  include Variable

  def self.keep_minimum_stock
    
    ## entrega una lista de listas donde muestra el producto con su min stock
    minimum_stock_list = StockMinimo.get_minimum_stock
    
    ## entrega una lista de lista donde muestra sku,nombre y cantidad
    stock = suma_stock()
    stock_a_pedir = {}

    minimum_stock_list.each do |mins|
      sku_a_pedir = mins[0].to_s
      minimo = mins[1].to_f
      stock.each do |d|
        if d['sku'] == sku_a_pedir
          minimo -= d['total'].to_i
          next if minimo <0
        end
      end

      ## cachar bien cuanto queremos pedir
      minimo = (minimo * 1.3).to_f
      producto = Product.find_by_sku(sku_a_pedir)
      factor =  (minimo / producto.lote_produccion).ceil

      ## cuanto debemos pedir nosotros para que nosotros estemos bien
      cantidad_a_pedir = producto.lote_produccion * factor

      if cantidad_a_pedir > 0
        if stock_a_pedir.key?(sku_a_pedir)
          stock_a_pedir[sku_a_pedir] += cantidad_a_pedir
        else
          stock_a_pedir[sku_a_pedir] = cantidad_a_pedir
        end
      else
        stock_a_pedir[sku_a_pedir] = 0
      end
      ## se agregan al diccionario los ingredientes (PROBAR)
      self.add_ingredientes(sku_a_pedir,minimo,stock_a_pedir)
    end

    puts '------------------------revisar diccionario start--------------------------------------'
    puts stock_a_pedir,"-------1--------", stock,"-------2--------", Inventory.get_inventory
    puts '------------------------revisar diccionario fin--------------------------------------'
    
    stock_a_pedir.each do |sku, cantidad|
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
    inventory = inv()
  #  p inv, "inven arriba", ingredientes, "ingredientes arriba"
    if ingredientes.length >0
      ingredientes.each do |i|
        if i.unidades_bodega*factor > inventory[i.sku.to_s].to_i
          if stock_a_pedir.key?(i.sku.to_s)
            stock_a_pedir[i.sku.to_s] += i.unidades_bodega * factor
          else
            stock_a_pedir[i.sku.to_s] = i.unidades_bodega * factor
          end
          add_ingredientes(i.sku.to_s,stock_a_pedir[i.sku.to_s],stock_a_pedir)
        else
          if stock_a_pedir.key?(i.sku.to_s)
            stock_a_pedir[i.sku.to_s] += 0
          else
            stock_a_pedir[i.sku.to_s] = 0
          end
        end
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
    futuro_envio = false
    pedidos = []
    
    #p "Pedir a grupos"
    
    if groups.length == 0
      puts "vacio"
      vacio = true
      groups = [1,2,3,4,5,6,7,8,9,11,12,13,14]
    end
    groups.each do |g|

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
        ingredientes_a_mover = []

        (0..factor-1).each do |fac|
          contador_espacio = 0
          ingredientes.each do |i|
            q_ingredient = ((i.unidades_bodega).ceil).to_i
            #p "Moviendo a despacho: ", i.sku
            if Logica.tengo_stock(i.sku, q_ingredient)
              #Logica.mover_a_despacho_para_minimo(i.sku, q_ingredient)
              ingredientes_a_mover.push([i.sku, q_ingredient])
              contador_espacio += q_ingredient
            end
          end
          if ingredientes_a_mover.count == total_ingredientes
            #p "Fabricar producto: ", sku
            if totalS.to_i-usedS.to_i-2 > contador_espacio
              ingredientes_a_mover.each do |i|
                Logica.mover_a_despacho_para_minimo(i[0], i[1])
              end
            end
            crear_pedido(sku, cantidad)
          end
        end
      else
        if sku == "1001" || sku == "1004" || sku == "1011" || sku == "1013" || sku == "1016"
          #p "Fabricar materia prima: ", sku
          crear_pedido(sku, cantidad)
          puts "-----------cerrar cantidad antes pedido "
        end
      end
    end
  end



  def self.crear_pedido(sku,cantidad)
    respuestaBodega = Bodega.Fabricar_gratis(sku, cantidad)
    
    if respuestaBodega != nil
      respuestaBodegaPedido = respuestaBodega["created_at"].to_time
    #  puts respuestaBodegaPedido
      respuestaBodegaDisponible = respuestaBodega["disponible"].to_time
     # puts respuestaBodegaDisponible
      respuestaBodegaTiempo = respuestaBodegaDisponible.to_i - respuestaBodegaPedido.to_i
     # puts respuestaBodegaTiempo
      puts " ------------------Creando pedido-------------------------------" 
     # p "Respuesta Pedido "+ respuestaBodegaPedido.to_s
     # p "Respuesta Disponible "+ respuestaBodegaDisponible.to_s
      respuesta = DateTime.now.to_time.to_i + respuestaBodegaTiempo
     # p "Respuesta Tiempo "+ Time.at(respuesta).to_s

      puts OrderRegister.create(sku: sku, cantidad: cantidad, fecha_llegada: Time.at(respuesta))
      puts " ------------------Pedido Creado-------------------------------"
    end
  end

  def self.suma_stock
    inventory = Inventory.get_inventory
    len = inventory.length()
    inventory2 = Inventory.get_inventory
    pedido = OrderRegister.all

    pedido.each do |p|
      (0..len-1).each do |i|
        if p["sku"] == inventory[i]["sku"]
          inventory2[i]["total"] = inventory2[i]["total"].to_i + p[:cantidad].to_i
        end
      end
    end
    return inventory2
  end

  def self.clean_order_register
    
    OrderRegister.all.each do |order|
      if order["fecha_llegada"].to_time.to_i < Time.now.to_i
        order.delete
      end
        #p "start time now", order["fecha_llegada"].to_time, Time.now,"finish time"  
    end
  end

  def self.clean
    Logica.clean_reception()
  end

  def self.inv
    dic = {}
    invent = Inventory.get_inventory
    invent.each do |a|
      dic[a["sku"]] = a["total"]
    end
    return dic
  end

end
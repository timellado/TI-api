require 'inventory'
require 'stock_minimo'
require 'logica'
require 'variable'
require_relative "../config/environment.rb"
require 'date'
require 'product_sku'

module ScheduleStock
  include Inventory
  include StockMinimo
  include Logica
  include Variable
  include ProductSKU

  def self.keep_minimum_stock
    
    ## entrega una lista de listas donde muestra el producto con su min stock
    minimum_stock_list = StockMinimo.get_minimum_stock
    
    ## entrega una lista de lista donde muestra sku,nombre y cantidad
    stock = self.suma_stock()
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

  def self.add_ingredientes(sku,cantidad,stock_a_pedir)
    # p "ingreso a la función add con sku: "+ sku.to_s + " cantidad: "+cantidad.to_s+" stock_a_pedir: ",stock_a_pedir
    product = Product.find_by_sku(sku)
    factor =  (cantidad / product.lote_produccion).ceil
    ingredientes = product.ingredients
    inventory = self.inv()
  #  p inv, "inven arriba", ingredientes, "ingredientes arriba"
    if ingredientes.length >0
      ingredientes.each do |i|
        if inventory.key?(i.sku.to_s)
          comparar = inventory[i.sku.to_s].to_i
        else
          comparar = 0
        end
        if i.unidades_bodega*factor > comparar
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
  
  def self.total_space(id_almacen)
    almacenes = JSON.parse(Bodega.all_almacenes.to_json)
    lista = []
    almacenes.each do |it|
      if it["_id"] == id_almacen
        usedS = it["usedSpace"]
        totalS = it["totalSpace"]
        lista.push(usedS)
        lista.push(totalS)
      end
    end
    return lista
  end

  def self.pedir_producto(sku, cantidad)
    cantidad_a_pedir = cantidad
    despacho_id = Variable.v_despacho
    cocina_id = Variable.v_cocina
    #almacenes = JSON.parse(Bodega.all_almacenes.to_json)
    #totalS = nil
    #usedS = nil
    tuplaDes = self.total_space(despacho_id)
    tuplaCoc = self.total_space(cocina_id)
    
    producto = Product.find_by_sku(sku)

    #Pedir a otros grupos
    #groups = producto.groups
    #vacio = false
    #futuro_envio = false
    #pedidos = []
    
    #p "Pedir a grupos"
    
    #if groups.length == 0
     # puts "vacio"
      #vacio = true
    groups = [1,2,3,4,5,6,7,8,9,11,12,13,14]
    #end
    respuesta = false
    
    groups.each do |g|
      puts "Pedir grupo: "+g.to_s+" sku:"+sku.to_s
      stock_grupo = Bodega.get_inventory_group(g)
      if stock_grupo.key?(sku.to_s)
        while cantidad_a_pedir > 0
          p stock_grupo[sku.to_s],"Stock grupo arriba!!!!!!"
          if stock_grupo[sku.to_s] >= cantidad_a_pedir
            pedido = JSON.parse(Bodega.Pedir(sku.to_s, cantidad_a_pedir, g.to_s).to_json)
            cantidad_a_pedir-= cantidad_a_pedir
          else
            pedido = JSON.parse(Bodega.Pedir(sku.to_s, stock_grupo[sku.to_s], g.to_s).to_json)
            cantidad_a_pedir-= stock_grupo[sku.to_s]
            p "LOOP INFINITOO"
            break
          end
        end
        break if cantidad_a_pedir <= 0
      end
    end
      # Si existe el pedido
      #if pedido
        # Si se acepta el pedido
       # if pedido["aceptado"] == true
          #respuesta = true
          #Ciclo hasta que la respuesta del grupo sea NO ENVIADO o que se cumpla la cantidad a pedir
        #  while respuesta && cantidad_por_pedir > 0
         #   pedido = JSON.parse(Bodega.Pedir(sku.to_s, 5, g.to_s).to_json)
          #  if pedido
           #   if pedido["aceptado"] == true
            #    respuesta = true
             #   cantidad_por_pedir -= 5
              #else
               # respuesta = false
          #    end
           # else
            #  respuesta = false
            #end
          #end
        #end
      #end
    #end
    # Si me falta por pedir ya recorridos todos los grupos

    if cantidad_a_pedir>0
      #Pedir en bodega
     # puts "bodega"
      if sku.to_s > "1016"
        puts "Voy a pedir "+cantidad.to_s+" de "+sku.to_s
        ingredientes = producto.ingredients
        factor = (cantidad / producto.lote_produccion).ceil
        schedule = false
        movidos = true
        total_ingredientes = ingredientes.count
        ingredientes_a_mover = []
       # p "-----------------------entrando al iterador !!!!!!!!!!!!!!!!!!!!!!"
        (0..factor-1).each do |fac|
        #  p "------------------------------------------FAC----------------------------"+fac.to_s
          contador_espacio = 0
         # p ingredientes.count
          ingredientes.each do |i|
            q_ingredient = ((i.unidades_bodega).ceil).to_i
          #  p "q_ingredient: "+ q_ingredient.to_s
            #p "Moviendo a despacho: ", i.sku
            if Logica.tengo_stock(i.sku.to_s, q_ingredient)
              #Logica.mover_a_despacho_para_minimo(i.sku, q_ingredient)
              puts "si tengo stock del ingrediente "+i.sku.to_s+" para el producto "+sku.to_s              
              ingredientes_a_mover.push([i.sku.to_s, q_ingredient])
              contador_espacio += q_ingredient
            end
          end
         # p "contador_espacio: "+ contador_espacio.to_s
         # p "ingredientesAmover: "+ ingredientes_a_mover.to_s
          if ingredientes_a_mover.count != total_ingredientes

            puts "NO TENGO INGREDIENTES PARA "+sku.to_s
          end
          break if ingredientes_a_mover.count != total_ingredientes
          if producto.tipo_produccion == "fabrica"
            if tuplaDes[1].to_i-tuplaDes[0].to_i-2 > contador_espacio
              ingredientes_a_mover.each do |i|
                  Logica.mover_a_despacho_para_minimo(i[0], i[1])
              end
            end
          else
            if tuplaCoc[1].to_i-tuplaCoc[0].to_i-2 > contador_espacio
              ingredientes_a_mover.each do |i|
                  Logica.mover_a_cocina_para_minimo(i[0], i[1])
              end
            end
          end
         # p "------------entrandoooo a crear_pedido1------------------------------"
          self.crear_pedido(sku.to_s, cantidad/factor)
        end
      else
        puts "Voy a pedir "+sku.to_s
        if sku.to_s == "1001" || sku.to_s == "1004" || sku.to_s == "1007" || sku.to_s == "1008" || sku.to_s == "1010" || sku.to_s == "1011" || sku.to_s == "1013" || sku.to_s == "1016"
          #p "Fabricar materia prima: ", sku
          self.crear_pedido(sku.to_s, cantidad*10)
         # puts "-----------cerrar cantidad antes pedido "
        end
      end
    end
  end

  def self.crear_pedido(sku,cantidad)
    "-----------------dentro crear_pedido---------------!!"
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
    pedido = OrderRegister.all
    inventario_dic = self.inv
    new_dic = {}
    nombre_sku = ProductSKU.get_sku_product
    nueva_lista_inventory = []

    pedido.each do |p|
      if inventario_dic.key?(p["sku"])
        inventario_dic[p["sku"]] = p[:cantidad].to_i + inventario_dic[p["sku"]].to_i
      else
        inventario_dic[p["sku"]] = p[:cantidad].to_i
      end

    end

    nombre_sku.each do |tupla|
      diccionario_f = {} 
      if inventario_dic.key?(tupla[0])
        diccionario_f["sku"] = tupla[0]
        diccionario_f["nombre"] = tupla[1]
        diccionario_f["total"] = inventario_dic[tupla[0]]
        nueva_lista_inventory.push(diccionario_f)
      end
    end

    return nueva_lista_inventory
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
    invent = Inventory.get_inventory()
    invent.each do |a|
      dic[a["sku"]] = a["total"]
    end
    return dic
  end

  def self.inv_group
    dic = {}
    invent = Inventory.get_inventory_for_group()
    invent.each do |a|
      dic[a["sku"]] = a["total"]
    end
    return dic
  end

end
require 'inventory'
require 'stock_minimo'
require 'logica'
require 'variable'
require 'date'
require 'product_sku'

module ScheduleStock
  include Inventory
  include StockMinimo
  include Logica
  include Variable
  include ProductSKU

  #Nueva Función cosas por pedir
  def self.get_stock_a_pedir
    #Diccionario Min Stock
    dic_min_stock = StockMinimo.get_minimum_stock_dic2

    #Diccionario Ingredientes Producto Excel
    dic_ingredients_product = StockMinimo.get_product_ingredient_dic

    #Diccionario Todos los Ingredientes Producto (incluye implicitos)
    dic_all_ingredients_product = StockMinimo.get_product_all_ingredient_dic

    #Diccionario Inventario + pedidos realizados
    dic_inventory = self.suma_inventario_mas_pedido

    #Diccionario Materia Prima
    dic_productor_materia_prima = StockMinimo.get_mi_materia_prima

    #Diccionario Todas Materia Prima
    dic_all_materia_prima = StockMinimo.get_all_materia_prima

    stock_a_pedir = {}

    factor_porcentaje = 1

    
    dic_min_stock.each do |i,j|
      #puts i
      prima = false
      #verifico si es materia prima o no y obtengo el lote
      if dic_all_materia_prima.key?(i)
        lote = dic_all_materia_prima[i]
        
        prima = true
      else
        lote = dic_ingredients_product[i]['lote']
        prima = false
      end
      
      factor_lote = factor_porcentaje*(j/lote).ceil
      
      if stock_a_pedir.key?(i)
        stock_a_pedir[i] += lote*factor_lote
      else
        stock_a_pedir[i] = lote*factor_lote
      end
      if dic_inventory.key?(i)
        stock_a_pedir[i] -= dic_inventory[i]
        dic_inventory.delete(i)
      end
      if prima == false
        dic_all_ingredients_product[i].each do |n, k|
          next if n == 'lote'
          next if n == 'tipo'
          if stock_a_pedir.key?(n)
            stock_a_pedir[n] += k*factor_lote
          else
            stock_a_pedir[n] = k*factor_lote
          end
          if dic_inventory.key?(n)
            stock_a_pedir[n] -= dic_inventory[n]
            dic_inventory.delete(n)
          end
        end
      end
    end
    return stock_a_pedir.sort_by{|k,v| k.to_i}.to_h
  end

  def self.suma_inventario_mas_pedido
    pedido = OrderRegister.all
    inventario_dic = self.inv
    # nombre_sku = ProductSKU.get_sku_product
    # nueva_lista_inventory = []

    pedido.each do |p|
      if inventario_dic.key?(p["sku"])
        inventario_dic[p["sku"]] = p[:cantidad].to_i + inventario_dic[p["sku"]].to_i
      else
        inventario_dic[p["sku"]] = p[:cantidad].to_i
      end

    end

    return inventario_dic #nueva_lista_inventory
  end

  def self.pedir_productos_faltantes
    start = Time.now
    p '---------------------------------------INICIO: '+Time.now.to_s+'-----------------------------------------------------------'
    self.pedir_materias_prima
    stock_a_pedir = self.get_stock_a_pedir
    dic_productor_materia_prima = StockMinimo.get_mi_materia_prima
    stock_a_pedir.each do |i,j|
      puts 'stock_a_pedir: '+i
      if j > 0
        next if dic_productor_materia_prima.key?(i)
        restante = self.pedir_producto_a_grupos(i,j)
        if restante > 0
          self.preparar_fabrica_y_fabricar(i,restante)
        end
      end
    end
    final = Time.now
    puts "Tiempo de pedir: " + ((final - start)/1.minute).to_s
    p '---------------------------------------Termino: '+Time.now.to_s+'-----------------------------------------------------------'
  end

  def self.pedir_producto_a_grupos(sku, cantidad)
    p '---------------------------------------INICIO PEDIR GRUPOS----------------------------------------------------------------'
    cantidad_a_pedir = cantidad
    groups = [1,2,3,4,5,6,7,8,9,11,12,13,14]
    groups.each do |g|
      stock_grupo = Bodega.get_inventory_group(g)
      #puts "sg", stock_grupo
      if stock_grupo.key?(sku.to_s)
        p "Stock grupo:  "+stock_grupo[sku.to_s].to_s
        if stock_grupo[sku.to_s] != nil
          if stock_grupo[sku.to_s] >= cantidad_a_pedir
            ## Por qué hacemos Json.parse?
            pedido = JSON.parse(Bodega.Pedir(sku.to_s, cantidad_a_pedir, g.to_s).to_json)
            cantidad_a_pedir-= cantidad_a_pedir
            break
          else
            pedido = JSON.parse(Bodega.Pedir(sku.to_s, stock_grupo[sku.to_s].floor, g.to_s).to_json)
            cantidad_a_pedir-= stock_grupo[sku.to_s]
          end
          break if cantidad_a_pedir <= 0   
        end   
      end
    end
    p '---------------------------------------FINISH PEDIR GRUPOS----------------------------------------------------------------'
    return cantidad_a_pedir
  end

  def self.preparar_fabrica_y_fabricar(sku,cantidad)
    #Diccionario Inventario
    dic_inventory = self.inv

    #Diccionario Ingredientes Producto Excel
    dic_ingredients_product = StockMinimo.get_product_ingredient_dic

    #Diccionario Materia Prima
    dic_productor_materia_prima = StockMinimo.get_mi_materia_prima

    #Diccionario Todas Materia Prima
    dic_all_materia_prima = StockMinimo.get_all_materia_prima


    p 'tipo '+sku   #Reviso si nosotros producimos esa materia prima
    if dic_productor_materia_prima.key?(sku)
      return
      #puts 'Soy una materia prima!! y me produces: '+sku
      #factoring = (cantidad/dic_productor_materia_prima[sku]).ceil
      #cantidad = cantidad*factoring
      #self.crear_pedido(sku,cantidad)
    end

    #Reviso si es materia prima y no la podemos producir
    if dic_all_materia_prima.key?(sku)
      puts 'Soy una materia prima!! y NO me produces: '+sku
      return
    end
    
    p '---------------------------------------INICIO PEDIR FABRICA----------------------------------------------------------------'
    #Mando a producir todo lo que pueda por lotes
    lote = dic_ingredients_product[sku]['lote']
    tipo = dic_ingredients_product[sku]['tipo']
    factoring = (cantidad/dic_ingredients_product[sku]['lote']).ceil
    cantidad = dic_ingredients_product[sku]['lote']*factoring
    loop_cantidad_lotes = (cantidad/lote).ceil
    

    puts 'cantidad: '+cantidad.to_s+' lote: '+lote.to_s+' loop_cantidad_lotes: '+loop_cantidad_lotes.to_s

    despacho_id = Variable.v_despacho
    cocina_id = Variable.v_cocina

    espacio_libre_despacho = Logica.contar_espacio_libre(despacho_id)
    espacio_libre_cocina = Logica.contar_espacio_libre(cocina_id)

    ### [espacio usado, espacio total]
    #puts "Voy a pedir "+cantidad.to_s+" de "+sku.to_s
    
    ingredientes =  dic_ingredients_product[sku].keys
    ingredientes.delete('lote')
    ingredientes.delete('tipo')

    total_ingredientes = dic_ingredients_product[sku].count - 2
    # p "-----------------------entrando al iterador !!!!!!!!!!!!!!!!!!!!!!"
    (0..loop_cantidad_lotes-1).each do |fac|
      ingredientes_a_mover = []
      contador_espacio = 0
      # p ingredientes.count
      ingredientes.each do |i|
        q_ingredient = dic_ingredients_product[sku][i]
        if Logica.tengo_stock(i, q_ingredient)
          #Logica.mover_a_despacho_para_minimo(i.sku, q_ingredient)
          puts "si tengo stock del ingrediente "+i+" para el producto "+sku
          ingredientes_a_mover.push([i, q_ingredient])
          contador_espacio += q_ingredient
        else
          puts ":( no tengo stock del ingrediente "+i+" para el producto "+sku
          break
        end
      end
      # NO PUEDO MOVER TODOS LOS INGREDIENTES PORQUE NO TENGO STOCK
      if ingredientes_a_mover.count != total_ingredientes
        puts "NO TENGO TODOS LOS INGREDIENTES PARA "+sku.to_s
        return false
      end
      # SI ES FABRICA
      if dic_ingredients_product[sku]["tipo"] == "fabrica"
        ## SI espacio libre despacho > espacio necesario
        if espacio_libre_despacho-2 > contador_espacio
          ingredientes_a_mover.each do |i|
              Logica.mover_a_despacho_para_minimo(i[0], i[1])
          end
          self.crear_pedido(sku, lote)
        end
        # COCINA
      else
        ## espacio libre cocina > espacio necesario
        if espacio_libre_cocina-2 > contador_espacio
          ingredientes_a_mover.each do |i|
              Logica.mover_a_cocina_para_minimo(i[0], i[1])
          end
          self.crear_pedido(sku, lote)
        end
      end
    end
    
    p '---------------------------------------FINISH PEDIR FABRICA----------------------------------------------------------------'
  end

  def self.clean_order_register
    start = Time.now
    OrderRegister.all.each do |order|

      if order["fecha_llegada"].to_time.to_i < Time.now.to_i
        order.delete
      end
        #p "start time now", order["fecha_llegada"].to_time, Time.now,"finish time"
    end
    final = Time.now
    puts "Tiempo de CLEAN ORDER REGISTER: " + ((final - start)/1.minute).to_s
  end

  def self.clean
    start = Time.now
    Logica.clean_reception()
    final = Time.now
    puts "Tiempo de clean: " + ((final - start)/1.minute).to_s
  end

  def self.inv
    dic = {}
    invent = Inventory.get_inventory()
    invent.each do |a|
      dic[a["sku"]] = a["total"]
    end
    return dic
  end

  def self.crear_pedido(sku,cantidad)
    p "-----------------dentro crear_pedido---------------!!"
    respuestaBodega = Bodega.Fabricar_gratis(sku, cantidad)

    if respuestaBodega != nil
      respuestaBodegaPedido = respuestaBodega["created_at"].to_time
    
      respuestaBodegaDisponible = respuestaBodega["disponible"].to_time
     
      respuestaBodegaTiempo = respuestaBodegaDisponible.to_i - respuestaBodegaPedido.to_i
     
      puts " ------------------Creando pedido-------------------------------"
 
      respuesta = DateTime.now.to_time.to_i + respuestaBodegaTiempo


      puts OrderRegister.create(sku: sku, cantidad: cantidad, fecha_llegada: Time.at(respuesta))
      puts " ------------------Pedido Creado-------------------------------"
    end
  end

  def self.pedir_materias_prima
    mi_inv = self.get_stock_a_pedir
    lote_materia = StockMinimo.get_mi_materia_prima
    lote_materia.each do |i,j|
      if mi_inv[i] > 0
        factor = (mi_inv[i]/lote_materia[i]).ceil
        p "pidiendo: "+i
      self.crear_pedido(i,lote_materia[i]*factor)
      end
    end
  end
#--------------------------------------------------ANTIGUO------------------------------------------------------------------------------------------
  #def self.keep_minimum_stock
  #  start = Time.now
#
  #  ## entrega una lista de listas donde muestra el producto con su min stock
  #  minimum_stock_list = StockMinimo.get_minimum_stock
#
  #  # NUEVA FUNCIÓN
  #  minimum_stock_list.each do |mins|
  #    self.min_stock_order_product(mins[0].to_s, mins[1].to_i)
  #  end
#
#
  #  # VIEJA FUNCIÓN
#
  #  ## entrega una lista de lista donde muestra sku,nombre y cantidad
  #  stock = self.suma_stock()
  #  stock_a_pedir = {}
#
  #  minimum_stock_list.each do |mins|
  #    sku_a_pedir = mins[0].to_s
  #    minimo = mins[1].to_f
  #    if stock.key?(sku_a_pedir)
  #      minimo -= stock[sku_a_pedir].to_i
  #      next if minimo < 0
  #    end
  #    # stock.each do |d|
  #    #   if d['sku'] == sku_a_pedir
  #    #     minimo -= d['total'].to_i
  #    #     next if minimo <0
  #    #   end
  #    # end
#
  #    ## cachar bien cuanto queremos pedir
  #    minimo = (minimo * 1.3).to_f
  #    producto = Product.find_by_sku(sku_a_pedir)
  #    factor =  (minimo / producto.lote_produccion).ceil
#
  #    ## cuanto debemos pedir nosotros para que nosotros estemos bien
  #    cantidad_a_pedir = producto.lote_produccion * factor
#
  #    if cantidad_a_pedir > 0
  #      if stock_a_pedir.key?(sku_a_pedir)
  #        stock_a_pedir[sku_a_pedir] += cantidad_a_pedir
  #      else
  #        stock_a_pedir[sku_a_pedir] = cantidad_a_pedir
  #      end
  #    else
  #      stock_a_pedir[sku_a_pedir] = 0
  #    end
  #    ## se agregan al diccionario los ingredientes (PROBAR)
  #    self.add_ingredientes(sku_a_pedir,minimo,stock_a_pedir)
  #  end
#
  #  puts '------------------------revisar diccionario start--------------------------------------'
  #  puts stock_a_pedir,"-------1--------", stock,"-------2--------"
  #  puts '------------------------revisar diccionario fin--------------------------------------'
#
  #  stock_a_pedir.each do |sku, cantidad|
  #    producto = Product.find_by_sku(sku)
  #    factor =  (cantidad / producto.lote_produccion).ceil
  #    cantidad_a_pedir = (producto.lote_produccion * factor).to_i
#
  #    stock.each do |s|
  #      if s['sku'] == sku
  #        cantidad -= s['total']
  #        factor =  (cantidad / producto.lote_produccion).ceil
  #        cantidad_a_pedir = (producto.lote_produccion * factor).to_i
  #      end
  #    end
#
  #    if cantidad_a_pedir>0
  #      self.pedir_producto(sku, cantidad_a_pedir)
  #    end
  #  end
  #  final = Time.now
  #  puts "Tiempo de mantener minimo stock: " + ((final - start)/1.minute).to_s
  #end

  #def self.add_ingredientes(sku, cantidad, stock_a_pedir)
  #  inventory = self.inv()
  #  product_ingredient = StockMinimo.get_product_ingredient
  #  ingredientes = product_ingredient[sku]
  #  ingredientes.each do |i |
  #    if inventory.key ? (i[0])
  #      cantidad_en_stock = inventory[i[0]].to_i
  #    else
  #      cantidad_en_stock = 0
  #    end
  #    if i[1] * factor > cantidad_en_stock
  #      if stock_a_pedir.key ? (i[0])
  #      stock_a_pedir[i[0]] += i[1] * factor
  #      else
  #        stock_a_pedir[i[0]] = i[1] * factor
  #      end
  #    add_ingredientes(i[0], stock_a_pedir[i[0]], stock_a_pedir)
  #    else
  #      if stock_a_pedir.key ? (i[0])
  #      stock_a_pedir[i[0]] += 0
  #      else
  #        stock_a_pedir[i[0]] = 0
  #      end
  #    end
  #  end
#
  #  ## INICIO FUNCIÓN ANTIGUA# p "ingreso a la función add con sku: " + sku.to_s + " cantidad: " + cantidad.to_s + " stock_a_pedir: ", stock_a_pedir
  #  product = Product.find_by_sku(sku)
  #  factor = (cantidad / product.lote_produccion).ceil
  #  ingredientes = product.ingredients
  #  inventory = self.inv()# p inv, "inven arriba", ingredientes, "ingredientes arriba"
  #  if ingredientes.length > 0
  #    ingredientes.each do |i |
  #      if inventory.key ? (i.sku.to_s)
  #        comparar = inventory[i.sku.to_s].to_i
  #      else
  #       comparar = 0
  #      end
  #      if i.unidades_bodega * factor > comparar
  #        if stock_a_pedir.key ? (i.sku.to_s)
  #        stock_a_pedir[i.sku.to_s] += i.unidades_bodega * factor
  #        else
  #          stock_a_pedir[i.sku.to_s] = i.unidades_bodega * factor
  #        end
  #        add_ingredientes(i.sku.to_s, stock_a_pedir[i.sku.to_s], stock_a_pedir)
  #      else
  #      if stock_a_pedir.key ? (i.sku.to_s)
  #        stock_a_pedir[i.sku.to_s] += 0
  #      else
  #        stock_a_pedir[i.sku.to_s] = 0
  #      end
  #    end
  #  end
  #  else
  #    return
  #  end
  #end

#
 # def self.pedir_producto(sku, cantidad)
    #Pedir a otros grupos
  #  cantidad_a_pedir = self.pedir_producto_a_grupos(sku, cantidad)
  #  p "PEDIDO A OTROS GRUPOS: " + (cantidad - cantidad_a_pedir).to_s
  #  if cantidad_a_pedir <= 0
  #    return true
  #  else
  #    ## Fabricar producto
  #    despacho_id = Variable.v_despacho
  #    cocina_id = Variable.v_cocina
  #    tuplaDes = self.total_space(despacho_id)
  #    tuplaCoc = self.total_space(cocina_id)
  #    ### [usedS,totalS]
#
#  #    producto = Product.find_by_sku(sku)
#
#  #    if sku.to_s > "1016"
#  #      puts "Voy a pedir "+cantidad.to_s+" de "+sku.to_s
#  #      ingredientes = producto.ingredients
#  #      factor = (cantidad / producto.lote_produccion).ceil
#  #      total_ingredientes = ingredientes.count
#  #      # p "-----------------------entrando al iterador !!!!!!!!!!!!!!!!!!!!!!"
#  #      (0..factor-1).each do |fac|
#  #        ingredientes_a_mover = []
#  #        #  p "------------------------------------------FAC----------------------------"+fac.to_s
#  #        contador_espacio = 0
#  #        # p ingredientes.count
#  #        ingredientes.each do |i|
#  #          q_ingredient = ((i.unidades_bodega).ceil).to_i
#  #          #p "q_ingredient: "+ q_ingredient.to_s
  #          #p "Moviendo a despacho: ", i.sku
  #          if Logica.tengo_stock(i.sku.to_s, q_ingredient)
  #            #Logica.mover_a_despacho_para_minimo(i.sku, q_ingredient)
  #            puts "si tengo stock del ingrediente "+i.sku.to_s+" para el producto "+sku.to_s
  #            ingredientes_a_mover.push([i.sku.to_s, q_ingredient])
  #            contador_espacio += q_ingredient
  #          else
  #            break
  #          end
  #        end
  #        # p "contador_espacio: "+ contador_espacio.to_s
  #        # p "ingredientesAmover: "+ ingredientes_a_mover.to_s
  #        if ingredientes_a_mover.count != total_ingredientes
  #          puts "NO TENGO TODOS LOS INGREDIENTES PARA "+sku.to_s
  #          return false
  #        end
  #        if producto.tipo_produccion == "fabrica"
  #          ## espacio libre despacho > espacio necesario
  #          if tuplaDes[1].to_i-tuplaDes[0].to_i-2 > contador_espacio
  #            ingredientes_a_mover.each do |i|
  #                Logica.mover_a_despacho_para_minimo(i[0], i[1])
  #            end
  #            self.crear_pedido(sku.to_s, producto.lote_produccion)
  #          end
  #        else
  #          ## espacio libre cocina > espacio necesario
  #          if tuplaCoc[1].to_i-tuplaCoc[0].to_i-2 > contador_espacio
  #            ingredientes_a_mover.each do |i|
  #                Logica.mover_a_cocina_para_minimo(i[0], i[1])
  #            end
  #            self.crear_pedido(sku.to_s, producto.lote_produccion)
  #          end
  #        end
  #      end
  #      return true
  #    else
  #      puts "Voy a pedir "+sku.to_s
  #      if sku.to_s == "1001" || sku.to_s == "1004" || sku.to_s == "1007" || sku.to_s == "1008" || sku.to_s == "1010" || sku.to_s == "1011" || sku.to_s == "1013" || sku.to_s == "1016"
  #        #p "Fabricar materia prima: ", sku
  #        self.crear_pedido(sku.to_s, cantidad_a_pedir)
  #        # puts "-----------cerrar cantidad antes pedido "
  #        return true
  #      end
  #    end
  #  end
# # end
# # 
# # def self.min_stock_order_product(sku, cantidad)
#    stock = 0
#    # reviso stock en almacenes
#    stock += self.revisar_stock_sku(sku)
#    # Reviso si hay pedidos realizados de este producto
#    stock += self.revisar_pedidos_sku(sku)
#
#    # comparo
#    if stock < cantidad
#      cantidad_a_pedir = cantidad - stock
#      realice_pedido = self.pedir_producto(sku, cantidad_a_pedir)
#      # 3. Pedir ingredientes para fabricarlo después
#      if !realice_pedido
#        ## Calculo cantidad si es que disminuyó
#        nuevo_stock = 0
#        # reviso stock en almacenes
#        nuevo_stock += self.revisar_stock_sku(sku)
#        # Reviso si hay pedidos realizados de este producto
#        nuevo_stock += self.revisar_pedidos_sku(sku)
#        cantidad_a_fabricar_via_ingredientes = cantidad - stock
#        product = Product.find_by_sku(sku)
#        factor =  (cantidad_a_fabricar_via_ingredientes / product.lote_produccion).ceil
#        ingredientes = StockMinimo.get_product_ingredient[sku]
#        if ingredientes.length > 0
#          ingredientes.each do |i|
#          end
#        end
#      end
#    end
# # end
##
# # def self.revisar_stock_sku(sku)
#    stock = 0
#    almacenes_id = Almacen.get_almacenes()
#    almacenes_id.each do |k|
#      next if k == Variable.v_despacho
#      bod = Bodega.get_skus_almacen(k)
#      results = JSON.parse(bod.to_json)
#      results.each do |i|
#        if i["_id"] == sku
#          stock += i["total"]
#        end
#      end
#    end
#    return stock
# # end
##
# # def self.revisar_pedidos_sku(sku)
#    stock = 0
#    pedidos = OrderRegister.where(sku: sku)
#    if pedidos != nil
#      pedidos.each do |p|
#        if p["sku"] == sku
#          stock += p[:cantidad].to_i
#        end
#      end
#    end
#    return stock
# # end

end
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



  #Nueva Función cosas por pedir - genera un diccionario con las cantidades que se debe pedir por cada sku
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
    factor_porcentaje = 0.7
    dic_min_stock.each do |i,j|

      prima = false
      #verifico si es materia prima o no y obtengo el lote
      if dic_all_materia_prima.key?(i)
        lote = dic_all_materia_prima[i]        
        prima = true
      else
        lote = dic_ingredients_product[i]['lote']
        prima = false
      end
      
      factor_lote = (factor_porcentaje*(j.to_f/lote.to_f)).ceil
      
      if stock_a_pedir.key?(i)
        stock_a_pedir[i] += lote*factor_lote.to_i
      else
        stock_a_pedir[i] = lote*factor_lote.to_i
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
            stock_a_pedir[n] += k*factor_lote.to_i
          else
            stock_a_pedir[n] = k*factor_lote.to_i
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

  #Devuelve un diccionario con nuestro inventario + Los productos que hemos pedido y no han llegado
  def self.suma_inventario_mas_pedido
    pedido = OrderRegister.all
    inventario_dic = self.inv

    pedido.each do |p|
      if inventario_dic.key?(p["sku"])
        inventario_dic[p["sku"]] = p[:cantidad].to_i + inventario_dic[p["sku"]].to_i
      else
        inventario_dic[p["sku"]] = p[:cantidad].to_i
      end
    end

    return inventario_dic #nueva_lista_inventory
  end

  #Esta función revisa cada uno de los productos faltantes y los pide, ya sea a grupo - fabrica - cocina (aún puede mejorar)
  #La idea es siempre pedir nuestras materias primas y sólo pedirle al resto los otros productos
  #Forma de mejorar a mi parecer puede ser: sólo pedir materias primas a los otros grupos que nosotros no podamos producir y confeccionar todo el resto
  def self.pedir_productos_faltantes
    start = Time.now
  #  p '---------------------------------------INICIO: '+Time.now.to_s+'-----------------------------------------------------------'
    self.pedir_materias_prima
    stock_a_pedir = self.get_stock_a_pedir
    dic_productor_materia_prima = StockMinimo.get_mi_materia_prima
    dic_all_materia_prima = StockMinimo.get_all_materia_prima
    
    stock_a_pedir.each do |i,j|
    #  puts 'stock_a_pedir: '+i
      if j > 0
        next if dic_productor_materia_prima.key?(i)
        break if i.to_i > 10000
        if dic_all_materia_prima.key?(i)
          restante = self.pedir_producto_a_grupos(i,j)
        else
          self.preparar_fabrica_y_fabricar(i,j)
        end
      end
    end
    
    final = Time.now
   # puts "Tiempo de pedir: " + ((final - start)/1.minute).to_s
   # p '---------------------------------------Termino: '+Time.now.to_s+'-----------------------------------------------------------'
  
  end

  #Función que toma un SKU y pide a todos los grupos la cantidad solicitada o lo máximo que presentan en su inventario devolviendo
  #la cantidad que falta por pedir
  def self.pedir_producto_a_grupos(sku, cantidad)
   # p '---------------------------------------INICIO PEDIR GRUPOS----------------------------------------------------------------'
    cantidad_a_pedir = cantidad
    groups = [1,2,3,4,5,6,7,8,9,11,12,13,14]
    groups.each do |g|
      stock_grupo = Bodega.get_inventory_group(g)
      #puts "sg", stock_grupo
      if stock_grupo.key?(sku.to_s)
     #   p "Stock grupo:  "+stock_grupo[sku.to_s].to_s
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
   # p '---------------------------------------FINISH PEDIR GRUPOS----------------------------------------------------------------'
    return cantidad_a_pedir
  end

  #Función que manda a hacer a fábrica o a cocina lo solicitado
  def self.preparar_fabrica_y_fabricar(sku,cantidad)
    #Diccionario Inventario
    dic_inventory = self.inv

    #Diccionario Ingredientes Producto Excel
    dic_ingredients_product = StockMinimo.get_product_ingredient_dic

    #Diccionario Materia Prima
    dic_productor_materia_prima = StockMinimo.get_mi_materia_prima

    #Diccionario Todas Materia Prima
    dic_all_materia_prima = StockMinimo.get_all_materia_prima


    #p 'tipo '+sku   #Reviso si nosotros producimos esa materia prima
    if dic_productor_materia_prima.key?(sku)
      return
      #puts 'Soy una materia prima!! y me produces: '+sku
      #factoring = (cantidad/dic_productor_materia_prima[sku]).ceil
      #cantidad = cantidad*factoring
      #self.crear_pedido(sku,cantidad)
    end

    #Reviso si es materia prima y no la podemos producir
    if dic_all_materia_prima.key?(sku)
    #  puts 'Soy una materia prima!! y NO me produces: '+sku
      return
    end
    
    #p '---------------------------------------INICIO PEDIR FABRICA----------------------------------------------------------------'
    #Mando a producir todo lo que pueda por lotes
    lote = dic_ingredients_product[sku]['lote']
    tipo = dic_ingredients_product[sku]['tipo']
    factoring = (cantidad.to_f/dic_ingredients_product[sku]['lote'].to_f).ceil
    cantidad = dic_ingredients_product[sku]['lote']*factoring.to_i
    
    #puts 'cantidad: '+cantidad.to_s+' lote: '+lote.to_s+' loop_cantidad_lotes: '+loop_cantidad_lotes.to_s
    
    despacho_id = Variable.v_despacho
    cocina_id = Variable.v_cocina
    
    espacio_libre_despacho = Logica.contar_espacio_libre(despacho_id)
    espacio_libre_cocina = Logica.contar_espacio_libre(cocina_id)
    
    
    
    
    ### [espacio usado, espacio total]
    #puts "Voy a pedir "+cantidad.to_s+" de "+sku.to_s
    
    ingredientes =  dic_ingredients_product[sku].keys
    ingredientes.delete('lote')
    ingredientes.delete('tipo')
    
    
    if dic_ingredients_product[sku]["tipo"] == "fabrica"
      tuplaLotesDes = ScheduleStock.numero_lotes_disponibles_a_producir(sku,cantidad,despacho_id)
      if tuplaLotesDes[0] == 0
        return false
      end
      if tuplaLotesDes[1] == 0
        return false
      end
      (0..tuplaLotesDes[0]-1).each do |fac|
        ingredientes_a_mover = []
        ingredientes.each do |i|
          q_ingredient = dic_ingredients_product[sku][i]
         # p "ingrediente: "+i.to_s+"cantidad: "+(q_ingredient*tuplaLotesDes[1]).to_s
          Logica.mover_a_despacho_para_minimo(i, q_ingredient*tuplaLotesDes[1])
        end
        if self.crear_pedido(sku, lote*tuplaLotesDes[1])
    #      p "pedido hecho"
        else
          Logica.clean_despacho
        end
      end
    end
      
    if dic_ingredients_product[sku]["tipo"] == "cocina"
      tuplaLotesCoc = ScheduleStock.numero_lotes_disponibles_a_producir(sku,cantidad,cocina_id)
      if tuplaLotesCoc[0] == 0
      return false
      end
      if tuplaLotesCoc[1] == 0
        return false
      end
      (0..tuplaLotesCoc[0]-1).each do |fac|
        ingredientes_a_mover = []
        ingredientes.each do |i|
          q_ingredient = dic_ingredients_product[sku][i]
         # p "ingrediente: "+i.to_s+"cantidad: "+(q_ingredient*tuplaLotesCoc[1]).to_s
          Logica.mover_a_cocina_para_minimo(i, q_ingredient*tuplaLotesCoc[1])    
        end
        if self.crear_pedido(sku, lote*tuplaLotesCoc[1])
    #      p "pedido hecho"
        else
          Logica.clean_despacho
        end
      end
    end
    
  #  p '---------------------------------------FINISH PEDIR FABRICA----------------------------------------------------------------'
  end

  #Función que limpia la tabla OrderRegister cuando ya han llegado los productos (revisa el tiempo estimado de llegada y ya pasó entonces llego el producto)
  def self.clean_order_register
    start = Time.now
    OrderRegister.all.each do |order|
      if order["fecha_llegada"].to_time.to_i < Time.now.to_i
        order.delete
      end
        #p "start time now", order["fecha_llegada"].to_time, Time.now,"finish time"
    end

    final = Time.now
  #  puts "Tiempo de CLEAN ORDER REGISTER: " + ((final - start)/1.minute).to_s
  end

  #limpia recepción
  def self.clean
    start = Time.now
    Logica.clean_reception()
    final = Time.now
  #  puts "Tiempo de clean: " + ((final - start)/1.minute).to_s
  end

  #Devuelve un diccionario con nuestro inventario
  def self.inv
    dic = {}
    invent = Inventory.get_inventory()
    invent.each do |a|
      dic[a["sku"]] = a["total"]
    end
    return dic
  end

  #Crea un pedido a la fábrica y lo guarda en OrderRegister para poder tener un registo de los pedidos
  def self.crear_pedido(sku,cantidad)
   # p "-----------------dentro crear_pedido---------------!!"
    respuestaBodega = Bodega.Fabricar_gratis(sku, cantidad)

    if respuestaBodega != nil
      respuestaBodegaPedido = respuestaBodega["created_at"].to_time
    
      respuestaBodegaDisponible = respuestaBodega["disponible"].to_time
     
      respuestaBodegaTiempo = respuestaBodegaDisponible.to_i - respuestaBodegaPedido.to_i
     
    #  puts " ------------------Creando pedido-------------------------------"
 
      respuesta = DateTime.now.to_time.to_i + respuestaBodegaTiempo


      puts OrderRegister.create(sku: sku, cantidad: cantidad, fecha_llegada: Time.at(respuesta))
    #  puts " ------------------Pedido Creado-------------------------------"
    end
  end

  #función que pide todas nuestras materias primas con las cantidades necesarias
  def self.pedir_materias_prima
    mi_inv = self.get_stock_a_pedir
    #lote_materia = StockMinimo.get_mi_materia_prima
    lote_materia = StockMinimo.get_all_materia_prima
    lote_materia.each do |i,j|
    factor = 0
      if mi_inv[i] > 0
        factor = (mi_inv[i].to_f/j.to_f).ceil
      #  p "pidiendo: "+i+' lote: '+lote_materia[i].to_s+' factor: '+factor.to_s+' inv: '+mi_inv[i].to_s
      self.crear_pedido(i,lote_materia[i]*factor.to_i)
      end
    end
  end

  #Toma un SKU, busca sus ingredientes y suma el espacio total que ocupan
  def self.suma_ingredientes(sku)
    skus = StockMinimo.get_product_ingredient_dic
    suma = 0
    skus[sku].each do |i,j|
      next if i == 'lote'
      next if i == 'tipo'
      suma += j
    end
    return suma
  end

  #Esta función toma el sku y cantidad, calcula cuanto es el máximo de lotes que puede hacer con el espacio disponible y cuantas veces debo hacer
  #esa cantidad es para obtener los iteradores en la función fabricar
  def self.numero_lotes_disponibles_a_producir(sku,cantidad,almacenid)
    resultado = []
    inventario = self.inv
    skus = StockMinimo.get_product_ingredient_dic
    ingredientes_suma = self.suma_ingredientes(sku)
    espacio_disponible = Logica.contar_espacio_libre(almacenid)-2
    lote = skus[sku]['lote']
    total_lotes = (cantidad.to_f/lote.to_f).ceil
    lotes_factibles = (espacio_disponible.to_f/ingredientes_suma.to_f).floor
    contador = total_lotes
  #  p "Espacio disponible: "+espacio_disponible.to_s
  #  p "Suma ingredientes: "+ingredientes_suma.to_s
    while contador > 0 do
      puedo = true
      skus[sku].each do |i,j|
        next if i == 'lote'
        next if i == 'tipo'
        if inventario[i] == nil
          puedo = false
          break
        end
        if inventario[i]<j*contador
          puedo = false
          break
        end
      end
      if puedo
        break
      end
      contador-=1
    end
  #  p "Lote: "+lote.to_s
  #  p "cantidad: "+cantidad.to_s
  #  p "contador: "+contador.to_s
  #  p "lotes factibles: "+ lotes_factibles.to_s

    num = (contador.to_f/lotes_factibles.to_f).floor
    if num == 0
      resultado.push(num.to_i+1)
      resultado.push(contador.to_i)      
    else
      resultado.push(num.to_i)
      resultado.push(lotes_factibles.to_i)
    end
  #  p resultado
    return resultado

  end


 

end
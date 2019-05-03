require 'inventory'
require 'stock_minimo'
require 'rufus-scheduler'
require 'logica'
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Inventory
  include StockMinimo
  include Logica

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
      factor =  (minimo / producto.lote_produccion).ceil #cuantos lotes debo producir

      ## cuanto debemos pedir nosotros para que nosotros estemos bien
      cantidad_a_pedir = producto.lote_produccion * factor
      if stock_a_pedir.key?(sku_a_pedir)
         stock_a_pedir[sku_a_pedir] += cantidad_a_pedir
      else
        stock_a_pedir[sku_a_pedir] = cantidad_a_pedir
      end
      #######################################################################
      ## se agregan al diccionario los ingredientes
      if producto.ingredients
        producto.ingredients.each do |i|
          if stock_a_pedir.key?(i.sku.to_s)
             stock_a_pedir[i.sku.to_s] += (i.cantidad_para_lote * factor)
          else
            stock_a_pedir[i.sku.to_s] = (i.cantidad_para_lote * factor)
          end
          productoi = Product.find_by_sku(i.sku.to_s)
          factori = (stock_a_pedir[i.sku.to_s] / productoi.lote_produccion).ceil
          ## se hace exactamente lo mismo que arriba para el nuevo ingrediente
          if productoi.ingredients
            productoi.ingredients.each do |j|
              if stock_a_pedir.key?(j.sku.to_s)
                 stock_a_pedir[j.sku.to_s] += j.cantidad_para_lote * factori
              else
                stock_a_pedir[j.sku.to_s] = j.cantidad_para_lote * factori
              end
              ## se hace exactamente lo mismo que arriba para el nuevo ingrediente por tercera vez
              productoj = Product.find_by_sku(j.sku.to_s)
              factorj = (stock_a_pedir[j.sku.to_s] / productoj.lote_produccion).ceil
              if productoj.ingredients
                productoj.ingredients.each do |k|
                  if stock_a_pedir.key?(k.sku.to_s)
                     stock_a_pedir[k.sku.to_s] += k.cantidad_para_lote * factorj
                  else
                    stock_a_pedir[k.sku.to_s] = k.cantidad_para_lote * factorj
                  end
                end
              end
            end
          end
        end
      end
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


  def self.minimum_general
    minimum_stock_list = StockMinimo.get_minimum_stock
    ## entrega una lista de lista donde muestra sku,nombre y cantidad
    #puts minimum_stock_list
    #puts current_products
    stock_a_pedir = {}

    minimum_stock_list.each do |mins|
      sku_a_pedir = mins[0].to_s
      minimo = mins[1].to_f
      ## cachar bien cuanto queremos pedir
      minimo = (minimo * 1.3).to_f
      ## -----------------------------------
      producto = Product.find_by_sku(sku_a_pedir)
      factor =  (minimo / producto.lote_produccion).ceil #cuantos lotes debo producir

      ## cuanto debemos pedir nosotros para que nosotros estemos bien
      cantidad_a_pedir = producto.lote_produccion * factor
      if stock_a_pedir.key?(sku_a_pedir)
         stock_a_pedir[sku_a_pedir] += cantidad_a_pedir
      else
        stock_a_pedir[sku_a_pedir] = cantidad_a_pedir
      end
    end
    return stock_a_pedir
  end
   

  def self.minimum_specific2
    puts "Minimos2"
    stock_actual = Inventory.get_inventory
    min = self.minimum_general
    min1 = min.clone
    puts min
 
    min1.each do |sku,cantidad|
      self.add_ingedients(sku,cantidad,min)
    end
    puts 'ingredientes'
    puts min
    min2 = min.clone
    min2.each do |sku,cantidad|
      product = Product.find_by_sku(sku)
      stock_actual.each do |d|
        if d['sku'] == sku
          cantidad -= d['total']
          if cantidad<0
            cantidad=0
          end
          lotes = (cantidad/product.lote_produccion).ceil #cuantos lotes puedo hacer
          u_total = lotes* product.lote_produccion   
          min[sku] = u_total
          
        end
      end
    end
    puts 'ingredientes min'
    puts min
    min1.each do |m,ca|
      if ca>0
        self.fabricar_producto(m,ca)
      end

    end  
  end

  def self.add_ingedients(sku,cantidad,dicc)
    product = Product.find_by_sku(sku)
    ingredientes = product.ingredients
    if ingredientes.length >0
      ingredientes.each do |ing|
        
        ing_sku = ing.sku
        ingrediente = Product.find_by_sku(ing_sku)
        lotes_padre = (cantidad.to_f/product.lote_produccion.to_f).ceil
        cantidad_hijo = lotes_padre.to_f*ing.unidades_bodega.to_f
        #cuanto ingrediente necesito = cantidad unidades padre * cantidad para 1 unida
        #cantidad_ingrediente = cantidad_padre.to_f * (ing.cantidad_para_lote.to_f/ing.lote_produccion.to_f)
       # puts sku
        #puts cantidad
        #puts product.lote_produccion
        #puts lotes_padre
        #puts cantidad_hijo
        #puts ing.unidades_bodega
        lotes_ingrediente = (cantidad_hijo.to_f/ingrediente.lote_produccion).ceil
        #lotes = (ing.unidades_bodega.to_f/cantidad_ingrediente.to_f).ceil #cuantos lotes necesito del ingrediente
        #u_total = lotes.to_f* ing.lote_produccion.to_f
        u_total = lotes_ingrediente * ingrediente.lote_produccion
        #puts lotes_ingrediente
        
        if dicc.key?(ing_sku)
          dicc[ing_sku] += u_total
        else
          dicc[ing_sku] = u_total
        end
        self.add_ingedients(ing_sku,u_total,dicc)
      end
    else
      return
    end
    
  end

  def self.fabricar_producto(sku,cantidad)
    puts sku,cantidad
    producto = Product.find_by_sku(sku)
    fabrica = false
    puedo_fabricar = false #puedo o nomandar a fabricarel producto dado sus ingredientes
    cuaanto_fabrico = 0
  
    #pedir a los grupos
    Group.all.each do |x|
      if x.grupo != 10
        pedido = JSON.parse(Bodega.Pedir(sku, cantidad, x.grupo).to_json)
        puts x.grupo
        if pedido
          if pedido["aceptado"]
            puts 'chao'
            fabrica = true
            return
          end
        end
      end   
    end

    if fabrica
        return 
    else
      # si es que tiene ingredientes  hay que mandar a produ lo que me alcance
      cuaanto_fabrico = self.cuanto_puedo_producir(sku)
      if cuaanto_fabrico >0
        #mover a despacho
        
        puts "mover despacho -------------------------------------------"
        puts cuaanto_fabrico
        puts '-----------------------------------------'
      end
      #con lo ingredientes que tengo 
      
    
        #ver cuantos de cada ingrediente tendgo
        #revisar si nuevo minimo cambia
          #mas grande, hago lo mismo
          #mas chico hago el nuevo minimo
          #ver si hay espacio para todo en despacho,
            #si hay, mover de uno, ver si esta en pulmon 

          #cuando esten todos, mando a producir
        
    end
   
  end


  def self.cuanto_puedo_producir(sku)
    puts 'cuanto',sku
    producto = Product.find_by_sku(sku)
    ingre = []
    # si es que tiene ingredientes  hay que mandar a produ lo que me alcance
    #con lo ingredientes que tengo 
    ingredientes = producto.ingredients
    if ingredientes.length > 0
      #todo lo que deberia pedir
      ingredientes.each do |ingrediente| 
        sku_i = ingrediente.sku
       
        ing = Product.find_by_sku(sku_i)
        lista_sku_recepcion = Logica.listar_no_vencidos(Variable.v_recepcion,sku_i)
        lista_sku_i1 = Logica.listar_no_vencidos(Variable.v_inventario1,sku_i)
        lista_sku_i2 = Logica.listar_no_vencidos(Variable.v_inventario2,sku_i)
        lista_sku_pulmon = Logica.listar_no_vencidos(Variable.v_pulmon,sku_i)
        #cuanto tengo en mi inventario de ese ingrediente
        total = lista_sku_i1.length+lista_sku_i2.length+lista_sku_pulmon.length+lista_sku_recepcion.length
        #cuantas unidades del padre equivale        
        lotes_padre  = (total/ingrediente.unidades_bodega.to_f).floor
        a_producir = lotes_padre*producto.lote_produccion

        ingre.push(a_prodicr)
      end

    else
      lista_sku_recepcion = Logica.listar_no_vencidos(Variable.v_recepcion,sku)
      lista_sku_i1 = Logica.listar_no_vencidos(Variable.v_inventario1,sku)
      lista_sku_i2 = Logica.listar_no_vencidos(Variable.v_inventario2,sku)
      lista_sku_pulmon = Logica.listar_no_vencidos(Variable.v_pulmon,sku)
      #cuanto tengo en mi inventario de ese ingrediente
      total = lista_sku_i1.length+lista_sku_i2.length+lista_sku_pulmon.length+lista_sku_recepcion.length
      lotes = (total/producto.lote_produccion).floor
      a_prodicr = lotes*producto.lote_produccion
      return a_prodicr
    end
    if ingre.length >0
      total = ingre.min
      return total
    else
      return 0
    end
  end


  def self.minimum_specific
    puts "Minimos"
    stock_actual = Inventory.get_inventory
    min1 = self.minimum_general
    min = min1.clone
    puts min
    min.each do |sku,cantidad|
      #cuanto ingrediente necesito = cantidad unidades padre * cantidad para 1 unida
      product = Product.find_by_sku(sku)
      ingredientes = product.ingredients
      #si tiene ingredientes 1 nivel
      if ingredientes.length >0
          ingredientes.each do |ing|
      
            #cuanto ingrediente necesito = cantidad unidades padre * cantidad para 1 unida
            cantidad_ingrediente = cantidad * (ing.cantidad_para_lote/ing.lote_produccion).to_f
            lotes = (cantidad_ingrediente/ing.cantidad_para_lote).ceil #cuantos lotes necesito del ingrediente
            u_total = lotes* ing.lote_produccion

            if min1.key?(ing.sku)
              min1[ing.sku] += u_total
            else
              min1[ing.sku] = u_total
            end
            product = Product.find_by_sku(ing.sku)
            ingredientes = product.ingredients
            #si tiene ingredientes 2 nivel
            if ingredientes.length >0
                ingredientes.each do |ing2|
                  
                  #cuanto ingrediente necesito = cantidad unidades padre * cantidad para 1 unida
                  cantidad_ingrediente = cantidad * (ing2.cantidad_para_lote/ing2.lote_produccion).to_f
                  lotes = (cantidad/ing2.cantidad_para_lote).ceil #cuantos lotes necesito del ingrediente
                  u_total = lotes* ing2.lote_produccion
                  if min1.key?(ing2.sku)
                    min1[ing2.sku] += u_total
                  else
                    min1[ing2.sku] = u_total
                  end
                  product = Product.find_by_sku(ing2.sku)
                  ingredientes = product.ingredients
                  #si tiene ingredientes 3 nivel
                  if ingredientes.length >0
                      ingredientes.each do |ing3|
                        
                        #cuanto ingrediente necesito = cantidad unidades padre * cantidad para 1 unida
                        cantidad_ingrediente = cantidad * (ing3.cantidad_para_lote/ing3.lote_produccion).to_f
                        lotes = (cantidad/ing3.cantidad_para_lote).ceil #cuantos lotes necesito del ingrediente
                        u_total = lotes* ing3.lote_produccion
                        if min1.key?(ing3.sku)
                          min1[ing3.sku] += u_total
                        else
                          min1[ing3.sku] = u_total
                        end
                        if ingredientes.length >0
                          ingredientes.each do |ing4|
                            
                            #cuanto ingrediente necesito = cantidad unidades padre * cantidad para 1 unida
                            cantidad_ingrediente = cantidad * (ing4.cantidad_para_lote/ing4.lote_produccion).to_f
                            lotes = (cantidad/ing4.cantidad_para_lote).ceil #cuantos lotes necesito del ingrediente
                            u_total = lotes* ing4.lote_produccion
                            if min1.key?(ing4.sku)
                              min1[ing4.sku] += u_total
                            else
                              min1[ing4.sku] = u_total
                            end
                            
                          end
                        end 
                      end
                  end 
                  
                end
            end 
          end
      end
    end  
    min2 = min1.clone
    min2.each do |sku,cantidad|
      product = Product.find_by_sku(sku)
      stock_actual.each do |d|
        if d['sku'] == sku
          cantidad -= d['total']
          if cantidad<0
            cantidad=0
          end
          lotes = (cantidad/product.lote_produccion).ceil #cuantos lotes necesito del ingrediente
          u_total = lotes* product.lote_produccion   
          min1[sku] = u_total
          
        end
      end
    end
    puts 'fin',min1
    min1.each do |m,ca|
      if ca>0
        self.fabricar_producto(m,ca)
      end

    end   
  end
  
  
  
    



 

 



   


  def self.pedir_producto(sku, cantidad)
    producto = Product.find_by_sku(sku)
    #Pedir a otros grupos
    groups = producto.groups
    vacio = false
    #groups_id = groups.map{|m| m.id()}
    puts '------------------------revisar groups_id start--------------------------------------'
    puts sku,cantidad
    puts '------------------------revisar groups_id fin--------------------------------------'
  
    puts '------------------------revisar groups start--------------------------------------'
    puts groups
    puts '------------------------revisar groups fin--------------------------------------'
  
    
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
          pedido = JSON.parse(Bodega.Pedir(sku.to_s, cantidad.to_s, g.to_s).to_json)
        else 
          pedido = JSON.parse(Bodega.Pedir(sku.to_s, cantidad.to_s, g.grupo.to_s).to_json)
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
          ingredientes_en_despacho = []
          ingredientes.each do |i|
            q_ingredient = (((i.cantidad_para_lote * factor) / i.lote_produccion).ceil * i.lote_produccion).to_i
            #p "Moviendo a despacho: ", i.sku
            if Logica.mover_a_despacho_para_minimo(i.sku, q_ingredient)
              ingredientes_en_despacho.push([i.sku, q_ingredient])
            end
          end
          if ingredientes_en_despacho.count == total_ingredientes
            #p "Fabricar producto: ", sku
            Bodega.Fabricar_gratis(sku, cantidad)
          else
            ingredientes_en_despacho.each do |i|
              #p "Sacar de despacho producto: ", i[0]
              Logica.sacar_de_despacho(i[0], i[1])
            end
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
    Logica.clean_reception
  end
end

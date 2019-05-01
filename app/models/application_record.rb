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
      factor =  (minimo / producto.lote_produccion).ceil
      ## cuanto debemos pedir nosotros para que nosotros estemos bien
      cantidad_a_pedir = producto.lote_produccion * factor
      if stock_a_pedir.key?(sku_a_pedir)
         stock_a_pedir[sku_a_pedir] += cantidad_a_pedir
      else
        stock_a_pedir[sku_a_pedir] = cantidad_a_pedir
      end
      ## se agregan al diccionario los ingredientes
      if producto.ingredients
        producto.ingredients.each do |i|
          if stock_a_pedir.key?(i.sku.to_s)
             stock_a_pedir[i.sku.to_s] += i.cantidad_para_lote * factor
          else
            stock_a_pedir[i.sku.to_s] = i.cantidad_para_lote * factor
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

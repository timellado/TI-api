require 'inventory'
require 'stock_minimo'
require 'rufus-scheduler'
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Inventory
  include StockMinimo

  def self.keep_minimum_stock
    minimum_stock_list = StockMinimo.get_minimum_stock
    current_products = Inventory.get_inventory
    stock = current_products[0]
    stock_a_pedir = {}
    minimum_stock_list.each do |mins|
      sku_a_pedir = mins[0].to_s
      minimo = mins[1].to_f
      if stock.key?(sku_a_pedir)
        minimo -= stock[sku_a_pedir]
      end
      minimo = (minimo * 1.3).to_f
      producto = Product.find_by_sku(sku_a_pedir)
      factor =  (minimo / producto.lote_produccion).ceil
      cantidad_a_pedir = producto.lote_produccion * factor
      if stock_a_pedir.key?(sku_a_pedir)
         stock_a_pedir[sku_a_pedir] += cantidad_a_pedir
      else
        stock_a_pedir[sku_a_pedir] = cantidad_a_pedir
      end
      if producto.ingredients
        producto.ingredients.each do |i|
          if stock_a_pedir.key?(i.sku.to_s)
             stock_a_pedir[i.sku.to_s] += i.cantidad_para_lote * factor
          else
            stock_a_pedir[i.sku.to_s] = i.cantidad_para_lote * factor
          end
          productoi = Product.find_by_sku(i.sku.to_s)
          factori = (stock_a_pedir[i.sku.to_s] / productoi.lote_produccion).ceil
          if productoi.ingredients
            productoi.ingredients.each do |j|
              if stock_a_pedir.key?(j.sku.to_s)
                 stock_a_pedir[j.sku.to_s] += j.cantidad_para_lote * factori
              else
                stock_a_pedir[j.sku.to_s] = j.cantidad_para_lote * factori
              end
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
    stock_a_pedir.each do |sku, cantidad|
      self.pedir_producto(sku, cantidad)
    end
  end
  
  def self.pedir_producto(sku, cantidad)
    producto = Product.find_by_sku(sku)
    #Pedir a otros grupos
    groups = producto.groups
    groups_id = groups.map{|m| m.id()}
    futuro_envio = false
    pedidos = []
    groups_id.each do |g|
      pedido = JSON.parse(Bodega.Pedir(sku, cantidad, g).to_json)
      pedidos.push(pedido)
    end
    pedidos.each do |ped|
      if ped["aceptado"]
        futuro_envio = true
      end
    end
    if !futuro_envio
      #Pedir en bodega
      if sku > "1016"
        ingredientes = producto.ingredients
        factor = (cantidad / producto.lote_produccion).ceil
        schedule = false
        movidos = true
        ingredientes.each do |i|
          q_ingredient = ((i.cantidad_para_lote * factor) / i.lote_produccion).ceil * i.lote_produccion
          if # sku_disponible(sku, q_ingredient)
            #Mover productos solicitados a despacho
            p "movido a despacho"
          elsif !schedule
            movidos = false
            minutos = Product.find_by_sku(i.sku.to_s).tiempo_produccion
            self.pedir_producto(i.sku, q_ingredient)
            scheduler = Rufus::Scheduler.new
            scheduler.in "#{minutos}m" do
              self.pedir_producto(sku, cantidad)
            end
          end
        end
        if movidos
          quantity = ((cantidad / producto.lote_produccion).ceil * producto.lote_produccion).to_i
          Bodega.Fabricar_gratis(sku, quantity)
        end
      else
        quantity = ((cantidad / producto.lote_produccion).ceil * producto.lote_produccion).to_i
        Bodega.Fabricar_gratis(sku, quantity)
      end
    end
  end
end

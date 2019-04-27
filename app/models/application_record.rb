require 'inventory'
require 'stock_minimo'
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
      cantidad_a_pedir = mins[1]*1.3.to_i
      producto = Product.find_by_sku(sku_a_pedir)
      if producto.ingredients

      end

      if stock.key?(mins[0].to_s)
        if stock[sku_a_pedir] < mins[1]
          cantidad_a_pedir -= stock[sku_a_pedir]
          self.pedir_producto(sku_a_pedir, cantidad_a_pedir)
        end
      else
        self.pedir_producto(sku_a_pedir, cantidad_a_pedir)
      end
    end
  end
  # problema del futuro
  def self.pedir_producto(sku, cantidad)
    groups = Product.find_by_sku(sku).groups
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

      Bodega.Fabricar_gratis(sku, cantidad)
    end
  end
end

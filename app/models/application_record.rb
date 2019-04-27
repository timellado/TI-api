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
    minimum_stock_list.each do |mins|
      sku_a_pedir = mins[0].to_s
      cantidad_a_pedir = mins[1]*1.3.to_i
      if stock.key?(mins[0].to_s)
        if stock[sku_a_pedir] < mins[1]
          cantidad_a_pedir -= stock[mins[0].to_s]
          #self.pedir_producto(sku_a_pedir, cantidad_a_pedir)
        end
      else
        #self.pedir_producto(sku_a_pedir, cantidad_a_pedir)
      end
    end
  end
  def self.pedir_producto(sku, cantidad)

  end
end

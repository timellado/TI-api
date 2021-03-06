require 'bodega'
require 'almacen'
require 'product_sku'
require 'variable'
require 'stock_minimo'
module Inventory
  include Bodega #todas las request a la bodega del profe estan en bodega.rb
  include Almacen
  include ProductSKU
  include Variable
  include StockMinimo

  def self.get_inventory
    lista_stock = []
    diccionario_sku = {}
    almacenes_id = Almacen.get_almacenes() ##Lista de todos los AlmacenesId
    #obtener match sku -> producto, no hay otra forma de hacerlo por tema de que al iterar diccionario_sku
    #sku_product no permite la llave si se crea como hash, por lo que hay que crearlo aca
    sku_product = {}
    sku_product_list = ProductSKU.get_sku_product()
    sku_product_list.each do |list|
      sku_product[list[0].to_s] = list[1]
    end
    almacenes_id.each do |k|
      next if k == Variable.v_despacho
      bod = Bodega.get_skus_almacen(k)
      results = JSON.parse(bod.to_json)
      results.each do |i|
        if diccionario_sku.key?(i["_id"])
          diccionario_sku[i["_id"]] += i["total"]
        else
          diccionario_sku[i["_id"]] = i["total"]
        end
      end
    end

    diccionario_sku.each do |k, v|
      stock = {}
      stock["sku"] = k
      stock["nombre"] = sku_product[k]
      stock["total"] = v
      lista_stock.push(stock)
    end
    return lista_stock
  end

  def self.get_inventory_for_group
    min_stock = StockMinimo.get_minimum_stock_dic2()
    inventory = get_inventory()
    mi_materia_prima = StockMinimo.get_mi_materia_prima
    new_inventory = []
    factor = 0.3

    inventory.each do |inv|
      new_dic = {}
      if mi_materia_prima.key?(inv["sku"].to_s)
        if min_stock.key?(inv["sku"].to_s)
          resta = inv["total"].to_i - min_stock[inv["sku"].to_s]
          next if resta <= 0
          new_dic["sku"] = inv["sku"]
          new_dic["nombre"] = inv["nombre"]
          new_dic["total"] = resta
        else
          next if (inv["total"]*factor).floor <= 100
          new_dic["sku"] = inv["sku"]
          new_dic["nombre"] = inv["nombre"]
          new_dic["total"] = (inv["total"]*factor).floor
        end
        new_inventory.push(new_dic)
      end
    end
    return new_inventory
  end



end

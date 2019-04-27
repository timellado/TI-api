require 'bodega'
require 'almacen'
require 'product_sku'
require 'variable'
module Inventory
  include Bodega #todas las request a la bodega del profe estan en bodega.rb
  include Almacen
  include ProductSKU
  include Variable

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
      results = JSON.parse(Bodega.get_skus_almacen(k).to_json)
      results.each do |i|
        #if i["_id"] != Variable.v_despacho
          if diccionario_sku.key?(i["_id"])
            diccionario_sku[i["_id"]] += i["total"]
          else
            diccionario_sku[i["_id"]] = i["total"]
          end
        #end      
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
end

require 'bodega'
require 'variable'
require 'product_sku'
require 'logica'
class RootsController < ApplicationController
  include Bodega
  include Variable
  include ProductSKU
  include Logica
  def index
    
    @results_root = JSON.parse(Bodega.all_almacenes().to_json)
    @cocina = Variable.v_cocina()
    @recepcion = Variable.v_recepcion()
    @despacho = Variable.v_despacho()
    @pulmon = Variable.v_pulmon()
    @inventario1 = Variable.v_inventario1()
    @inventario2 = Variable.v_inventario2()

    @sku_product_list = ProductSKU.get_sku_product()
    @lista_stock = Inventory.get_inventory

    @results_despacho = JSON.parse(Bodega.get_skus_almacen(@despacho).to_json)
    @results_recepcion = JSON.parse(Bodega.get_skus_almacen(@recepcion).to_json)
    @results_pulmon = (Bodega.get_skus_almacen(@pulmon).to_json)
    @results_inventario1 = JSON.parse(Bodega.get_skus_almacen(@inventario1).to_json)
    @results_inventario2 = JSON.parse(Bodega.get_skus_almacen(@inventario2).to_json)
    @results_cocina = JSON.parse(Bodega.get_skus_almacen(@cocina).to_json)

  end
end

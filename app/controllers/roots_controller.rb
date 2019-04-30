require 'bodega'
require 'variable'
class RootsController < ApplicationController
  include Bodega
  include Variable
  def index
    @results_root = JSON.parse(Bodega.all_almacenes().to_json)
    @cocina = Variable.v_cocina()
    @recepcion = Variable.v_recepcion()
    @despacho = Variable.v_despacho()
    @pulmon = Variable.v_pulmon()
    @inventario1 = Variable.v_inventario1()
    @inventario2 = Variable.v_inventario2()
  end
end

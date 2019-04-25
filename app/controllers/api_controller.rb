
require 'bodega'
class ApiController < ApplicationController
include Bodega #todas las request a la bodega del profe estan en bodega.rb
  skip_before_action :verify_authenticity_token

  def index
    #para probar los metodos de la bodega, pner el metodo aqui y hacer un get a http://localhost:3000/orders
    #get_Prod_almacen_sku("5cbd3ce444f67600049431e9", "1001")
    #render status: 200, json: {
     # sku: 'ola'

    #}.to_json
  end



  def create_order
    #se crea la orden
    @order = Order.new(order_params)
    #si se crea bien, se responde
    if @order.save
      render status: 200, json: {
        sku: @order[:Sku],
        cantidad: @order[:Cantidad],
        almacenId: @order[:Almacen_id],
        aceptado: @order[:Aceptado],
        despachado: @order[:Despachado],
        precio: @order[:Precio]
  
      }.to_json
    else
    
    end
  end

  def order_params
      params.permit(:Id_o, :Sku, :Cantidad, :Almacen_id, :Aceptado,:Despachado,:Precio)
  end


end

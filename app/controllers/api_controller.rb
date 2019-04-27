require 'inventory'
class ApiController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    #para probar los metodos de la bodega, pner el metodo aqui y hacer un get a http://localhost:3000/orders
    #get_Prod_almacen_sku("5cbd3ce444f67600049431e9", "1001")


    ## Se itera sobre los almacenesId provenientes de una lista que es retornada por la función
    ## get_almacenes, luego se llama a la Api del Profesor para pedir los Sku con sus stock
    ## de cada almacen, para luego guardarlos en un diccionario con el resumen total de todos los sku.
    ## finalmente render Json retorna un json con los datos esperados
    lista_stock = Inventory.get_inventory
    render json: lista_stock.to_json
    ##results = JSON.parse(Fabricar_gratis('1016','80').to_json)
    ##render json: results
    ##results2 = JSON.parse(all_almacenes().to_json)
    ##puts results2


    #results.each do |i|
    #  puts i["_id"]
    #end
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

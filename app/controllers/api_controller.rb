require 'inventory'
require 'logica'
require 'bodega'
require 'variable'
class ApiController < ApplicationController
include Inventory
include Logica
include Bodega
include Variable

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

    rescue ActiveRecord::RecordNotFound => e
      render json: {
        error: e.to_s
      }, status: :service_unavailable


    #results.each do |i|
    #  puts i["_id"]
    #end
  end

  def create_order
    #se crea la orden
    @order = Order.new(order_params)

    ## caso en que tenemos excedente de stock
    if Logica.sku_disponible(@order[:sku],@order[:cantidad])
        @order.aceptado = true
          @order.despachado = true

      if @order.save
        render status: 200, json: {
          sku: @order[:sku],
          cantidad: @order[:cantidad],
          almacenId: @order[:almacen_id],
          aceptado: @order[:aceptado],
          ## revisar despachado
          despachado: @order[:despachado],
          precio: @order[:precio]
        }.to_json

    else
      render status: 400, json: {
        message: "Formato invalido"}
    end
      Logica.mover_productos_a_despacho_y_despachar(@order[:sku],@order[:cantidad],@order[:almacenId])

      #Logica.despachar_a_grupo(@order[:Sku],@order[:Cantidad],@order[:Almacen_id])


    ## caso en que tenemos materia prima para enviar
    elsif Logica.validar_envio_materia_prima(@order[:sku], @order[:cantidad])

      @order.aceptado = true
      #Logica.despachar_a_grupo(@order[:Sku],@order[:Cantidad],@order[:Almacen_id])
      @order.despachado = true

      if @order.save
        render status: 200, json: {
          sku: @order[:sku],
          cantidad: @order[:cantidad],
          almacenId: @order[:almacenId],
          aceptado: @order[:aceptado],
          ## revisar despachado
          despachado: @order[:despachado],
          precio: @order[:precio]
        }.to_json

    else
      render status: 400, json: {
        message: "Formato invalido"}
    end
      Logica.mover_productos_a_despacho_y_despachar(@order[:sku],@order[:cantidad], @order[:almacenId])



    else

    render status: 200, json: {
        sku: @order[:sku],
         cantidad: @order[:cantidad],
         almacenId: @order[:almacenId],
         aceptado: false,
         despachado: false,
         precio: @order[:precio]
       }.to_json
    end

    #si se crea bien, se responde

    rescue ActiveRecord::RecordNotFound => e
    render json: {
      error: e.to_s
    }, status: :service_unavailable

  end

  def order_params
    defaults = { aceptado: false, despachado: false, precio: 1}
    params.permit(:sku, :cantidad, :almacenId, :aceptado, :despachado, :precio).reverse_merge(defaults)
  end
end

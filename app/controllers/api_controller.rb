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
    if Logica.sku_disponible(@order[:Sku],@order[:Cantidad])
      Logica.mover_productos_a_despacho(@order[:Sku],@order[:Cantidad])
      @order.Aceptado = true
      Logica.despachar_a_grupo(@order[:Sku],@order[:Cantidad],@order[:Almacen_id])
      @order.Despachado = true


    ## caso en que tenemos materia prima para enviar
    elsif Logica.validar_envio_materia_prima(@order[:Sku], @order[:Cantidad])
      Logica.mover_productos_a_despacho(@order[:Sku],@order[:Cantidad])
      @order.Aceptado = true
      Logica.despachar_a_grupo(@order[:Sku],@order[:Cantidad],@order[:Almacen_id])
      @order.Despachado = true


    else
    render status: 200, json: {
        sku: @order[:Sku],
         cantidad: @order[:Cantidad],
         almacenId: @order[:Almacen_id],
         aceptado: false,
         despachado: false,
         precio: @order[:Precio]
       }.to_json
    end

    #si se crea bien, se responde
    if @order.save
      render status: 200, json: {
        sku: @order[:Sku],
        cantidad: @order[:Cantidad],
        almacenId: @order[:Almacen_id],
        aceptado: @order[:Aceptado],
        ## revisar despachado
        despachado: @order[:Despachado],
        precio: @order[:Precio]
      }.to_json
    else
      render status: 400, json: {
        message: "Formato invalido"}
    end

    rescue ActiveRecord::RecordNotFound => e
    render json: {
      error: e.to_s
    }, status: :service_unavailable

  end

  def order_params
    defaults = { Aceptado: false, Despachado: false}
    params.permit(:Sku, :Cantidad, :Almacen_id, :Aceptado, :Despachado, :Precio).reverse_merge(defaults)
  end
end

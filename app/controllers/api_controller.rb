
require 'bodega'
require 'almacen'
class ApiController < ApplicationController
include Bodega
include Almacen #todas las request a la bodega del profe estan en bodega.rb
  skip_before_action :verify_authenticity_token

  def index
    #para probar los metodos de la bodega, pner el metodo aqui y hacer un get a http://localhost:3000/orders
    #get_Prod_almacen_sku("5cbd3ce444f67600049431e9", "1001")


    ## Se itera sobre los almacenesId provenientes de una lista que es retornada por la función
    ## get_almacenes, luego se llama a la Api del Profesor para pedir los Sku con sus stock
    ## de cada almacen, para luego guardarlos en un diccionario con el resumen total de todos los sku.
    ## finalmente r Json retorna un json con los datos esperados
    diccionario_sku = {}
    diccionario_sku[3] = 62
    diccionario_sku[4] = 50
    almacenes_id = get_almacenes() ##Lista de todos los AlmacenesId
    almacenes_id.each do |k|
      results = JSON.parse(get_skus_almacen(k).to_json)
      results.each do |i|
        ## Arreglar if -> no está bien implementado
        if diccionario_sku[i["_id"]["sku"]].empty? 

          diccionario_sku[i["_id"]["sku"]] = i["total"]
        else
          diccionario_sku[i["_id"]["sku"]] += i["total"]
        end
      end

      ##puts diccionario_sku
    ##  
    ##}
    end

    render json: diccionario_sku.to_json
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

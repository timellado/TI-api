
require 'bodega'
require 'almacen'
require 'product_sku'
class ApiController < ApplicationController
include Bodega #todas las request a la bodega del profe estan en bodega.rb
include Almacen
include ProductSKU
  skip_before_action :verify_authenticity_token

  def index
    #para probar los metodos de la bodega, pner el metodo aqui y hacer un get a http://localhost:3000/orders
    #get_Prod_almacen_sku("5cbd3ce444f67600049431e9", "1001")


    ## Se itera sobre los almacenesId provenientes de una lista que es retornada por la función
    ## get_almacenes, luego se llama a la Api del Profesor para pedir los Sku con sus stock
    ## de cada almacen, para luego guardarlos en un diccionario con el resumen total de todos los sku.
    ## finalmente render Json retorna un json con los datos esperados
    lista_stock = []
    diccionario_sku = {}
    almacenes_id = get_almacenes() ##Lista de todos los AlmacenesId
    #obtener match sku -> producto, no hay otra forma de hacerlo por tema de que al iterar diccionario_sku
    #sku_product no permite la llave si se crea como hash, por lo que hay que crearlo aca
    sku_product = {}
    sku_product_list = get_sku_product()
    sku_product_list.each do |list|
      sku_product[list[0].to_s] = list[1]
    end
    almacenes_id.each do |k|
      results = JSON.parse(get_skus_almacen(k).to_json)
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

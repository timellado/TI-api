class ApiController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
  end



  def create_order

    @order = Order.create(order_params)

    render json: {status: 'succes'}, status: :ok


  end

  def order_params
      params.permit(:Id_o, :Sku, :Cantidad, :Almacen_id, :Aceptado,:Despachado,:Precio)
  end


end

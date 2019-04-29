require 'bodega'
class RootsController < ApplicationController
  include Bodega
  def index
    results = JSON.parse(Bodega.all_almacenes().to_json)
    render json: results
  end
end

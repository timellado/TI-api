require 'bodega'
module Almacen
include Bodega

    def get_almacenes()
        lista_almacenes = []
        results = JSON.parse(all_almacenes().to_json)
        results.each do |i|
            lista_almacenes.push(i["_id"])
        end
        return lista_almacenes
    end
end

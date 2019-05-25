require 'bodega'
require 'variable'
require 'httparty'
require 'hash'

module Oc

    include Variable
    $uri = "https://integracion-2019-dev.herokuapp.com/oc/"
    cliente = '5cbd31b7c445af0004739bec'

    def self.get_oc_profe(proveedor, sku,fechaEntrega, cantidad, precioUnitario, canal)
        response = HTTParty.put($uri+'crear',
            :headers =>{'Content-Type' => 'application/json'},
            :body => {'cliente' => cliente,'proveedor' => proveedor, 'sku' =>sku, 
            'fechaEntrega' => fechaEntrega, 'cantidad' => cantidad, 'precioUnitario' => precioUnitario,
            'canal'=> canal})
            results = response.parsed_response
           # puts results
        return results
    end

    def self.get_oc_profe_id(proveedor, sku,fechaEntrega, cantidad, precioUnitario, canal)
        oc_json = JSON.parse(get_oc_profe(proveedor, sku,fechaEntrega, cantidad, precioUnitario, canal).to_json)
        id = oc_json["_id"]
        return id
    end

end
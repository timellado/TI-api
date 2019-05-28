require 'bodega'
require 'variable'
require 'httparty'
require 'hash'

module Oc

    include Variable
    $uril = "https://integracion-2019-prod.herokuapp.com/oc/"
    

    def self.get_oc_profe(proveedor, sku,fechaEntrega, cantidad, precioUnitario, canal)
        cliente = Group.find_by_grupo(10).id_prod
        urlNotificacion = "https://www.wikipedia.org/"
        response = HTTParty.put($uril+'crear',
            :headers =>{'Content-Type' => 'application/json'},
            :body => {'cliente' => cliente,'proveedor' => proveedor, 'sku' =>sku,
            'fechaEntrega' => fechaEntrega.to_i, 'cantidad' => cantidad, 'precioUnitario' => precioUnitario,
            'canal'=> canal, "urlNotificacion" => urlNotificacion}.to_json)
            results = response.parsed_response
           # p response.code, cliente, proveedor, sku, fechaEntrega,cantidad,precioUnitario,canal
            puts results
        return results
    end

    def self.get_oc_profe_id(proveedor, sku,fechaEntrega, cantidad, precioUnitario, canal)
        oc_json = JSON.parse(get_oc_profe(proveedor, sku,fechaEntrega, cantidad, precioUnitario, canal).to_json)
        # p oc_json
        id = oc_json["_id"]
        return id
    end


    def self.get_info_oc(id)
      response = HTTParty.get("https://integracion-2019-dev.herokuapp.com/oc/"+'obtener/'+id.to_s,
      :headers =>{'Content-Type' => 'application/json'})
      puts "Request API OC hecha para OC de otro grupo"
      results = JSON.parse(response.to_s)
      results = results[0]
      #self.save_data(results)
      return results
    end

    def self.accept_order(oc_id)
        response = HTTParty.post($uril+'recepcionar/'+oc_id,
            :headers =>{'Content-Type' => 'application/json'},
            :body =>{'id' => oc_id}.to_json)
            puts "Aceptar orden: " +oc_id.to_s
            results = JSON.parse(response.to_s)
            results = results[0]
            return results
    end

    def self.reject_order(oc_id,msn)
        response = HTTParty.post($uril+'rechazar/'+oc_id,
            :headers =>{'Content-Type' => 'application/json'},
            :body =>{'id' => oc_id,'rechazo'=> msn}.to_json)
            puts "Rechazar orden: " +oc_id.to_s
            results = JSON.parse(response.to_s)
            results = results[0]
            return results

    end

    def self.anular_order(oc_id,msn)
        response = HTTParty.delete($uril+'anular/'+oc_id,
            :headers =>{'Content-Type' => 'application/json'},
            :body =>{'id' => oc_id,'anulacion'=> msn}.to_json)
            puts "Anular orden: " +oc_id.to_s
            results = JSON.parse(response.to_s)
            results = results[0]
            return results

    end




end

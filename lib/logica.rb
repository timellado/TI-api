require 'inventory'
require 'stock_minimo'
require 'bodega'
require 'almacen'
require 'variable'
module Logica
include Inventory
include StockMinimo
include Bodega
include Almacen
include Variable

## esta función retorna true siesque el pedido de otro grupo lo podemos 
## enviar y false en el caso contrario

    def self.sku_disponible(sku, cantidad_pedida)
        lista_sku = Inventory.get_inventory()
        got_sku = false
        stock = 0
        lista_sku.each do |js|
            if js["sku"] == sku
                    got_sku = true
                    stock = js["total"]
            end
        end
        return got_sku && self.validar_stock(sku, cantidad_pedida, stock)
    end

## Función que valida si lo pedido por otro grupo menos el stock que tenemos es mayor 
## que el stock min que debemos soportar 

    def self.validar_stock(sku, cantidad, stock)
        lista_skus_min = StockMinimo.get_minimum_stock()
        lista_skus_min.each do |li|
            if li[0] == sku
                ## esto representa que si el stock que tenemos menos lo que nos piden es mayor
                ## que el stock min entonces se puede hacer la transacción
                if li[1] < stock-cantidad
                    return true
                end
            else 
                return true
            end
        end
        return false
    end

    def self.listar_sku_id(sku)
        lista_id = []
        ## Revisar almacenes
        lista_id.concat (self.listar_no_vencidos(Variable.v_recepcion,sku))
        lista_id.concat (self.listar_no_vencidos(Variable.v_inventario1,sku))
        lista_id.concat (self.listar_no_vencidos(Variable.v_inventario2,sku))
        lista_id.concat (self.listar_no_vencidos(Variable.v_pulmon,sku))
        lista_id.concat (self.listar_no_vencidos(Variable.v_cocina,sku))
        lista_id = lista_id.sort{ |a,b| a[1]<=> b[1]}
        return lista_id
    end

    def self.listar_no_vencidos(almacen_id,sku)
        lista_id = []

        ## Revisar recepción
        jsn = JSON.parse(Bodega.get_Prod_almacen_sku(almacen_id, sku).to_json)
        jsn.each do |j|
            lista_id.append [j["_id"],j["vencimiento"]]
        end 
        return lista_id
    end

    def self.mover_productos_a_despacho(sku,cantidad)
        lista_ids_sku = self.listar_sku_id(sku)
        (0..cantidad-1).each{
            |i| Bodega.Mover_almacen(Variable.v_despacho,lista_ids_sku[i][0])}
    end
end
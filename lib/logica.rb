require 'inventory'
require 'stock_minimo'
module Logica
include Inventory
include Stock_minimo

## esta función retorna true siesque el pedido de otro grupo lo podemos 
## enviar y false en el caso contrario

    def self.ver_sku(sku, cantidad_pedida)
       lista_sku = Inventory.get_inventory()
       got_sku = false
       stock = 0
       lista_sku.each do |js|
       if js["sku"] == sku
            got_sku = true
            stock = js["total"]
       end

       return got_sku && self.validar_stock(sku, cantidad_pedida, stock)
    end

## Función que valida si lo pedido por otro grupo menos el stock que tenemos es mayor 
## que el stock min que debemos soportar 

    def self.validar_stock(sku, cantidad, stock)
        lista_skus_min = Stock_minimo.get_minimum_stock()
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

end
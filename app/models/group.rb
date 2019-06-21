require 'logica'
class Group < ApplicationRecord
    has_and_belongs_to_many :products, dependent: :destroy
    
    def enviar_materia(sku,cantidad,almacen_destino, oc)
        Logica.mover_productos_a_despacho_y_despachar(sku,cantidad,almacen_destino, oc)
    end
end

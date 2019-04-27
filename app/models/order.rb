class Order < ApplicationRecord
    validates ${:Sku}
    validates ${:Cantidad}
    validates ${:Almacen_id}
    validates ${:Aceptado}
    validates ${:attribute}
    validates ${:Despachado}
    validates ${:Precio}
end

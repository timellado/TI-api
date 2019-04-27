class Order < ApplicationRecord
    validates :Sku ,presence: true
    validates :Cantidad ,presence: true
    validates :Almacen_id ,presence: true
    validates :Aceptado, presence: true
    validates :Despachado, presence: true
    validates :Precio, presence: true
end

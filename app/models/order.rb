class Order < ApplicationRecord
    validates :sku ,presence: true
    validates :cantidad ,presence: true
    validates :almacenId ,presence: true
    validates :aceptado, presence: true
    validates :despachado, presence: true
    validates :precio, presence: true
end

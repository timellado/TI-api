class Order < ApplicationRecord
    validates :sku ,presence: true
    validates :cantidad ,presence: true
    validates :almacenId ,presence: true
    validates :aceptado, presence: true
    validates :despachado, presence: true
    validates :precio, presence: true
    def self.min_stock
        puts "--------min_stock---------"
    end
end

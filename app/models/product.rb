class Product < ApplicationRecord
    has_and_belongs_to_many :ingredients, dependent: :destroy
    has_and_belongs_to_many :groups, dependent: :destroy
end

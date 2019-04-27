class CreateProductsIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :products_ingredients do |t|
      t.references :product, foreign_key: true
      t.references :ingredient, foreign_key: true
    end
  end
end

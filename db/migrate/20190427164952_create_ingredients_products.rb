class CreateIngredientsProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients_products do |t|
      t.references :ingredient, foreign_key: true
      t.references :product, foreign_key: true
    end
  end
end

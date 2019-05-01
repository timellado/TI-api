class AddSkuProdToIngredients < ActiveRecord::Migration[5.1]
  def change
    add_column :ingredients, :sku_product, :string
  end
end

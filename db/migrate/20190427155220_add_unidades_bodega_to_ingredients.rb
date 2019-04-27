class AddUnidadesBodegaToIngredients < ActiveRecord::Migration[5.1]
  def change
    add_column :ingredients, :unidades_bodega, :float
    add_column :ingredients, :cantidad_para_lote, :float
  end
end

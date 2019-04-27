class RemoveNombreFromIngredients < ActiveRecord::Migration[5.1]
  def change
    remove_column :ingredients, :nombre
    remove_column :ingredients, :precio_venta
    remove_column :ingredients, :vencimiento
    remove_column :ingredients, :espacio_ocupado_unidad
    remove_column :ingredients, :tiempo_produccion  
  end
end

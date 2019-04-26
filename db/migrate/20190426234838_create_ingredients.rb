class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.string :sku
      t.string :nombre
      t.integer :precio_venta
      t.integer :vencimiento
      t.float :espacio_ocupado_unidad
      t.integer :lote_produccion
      t.integer :tiempo_produccion

      t.timestamps
    end
  end
end

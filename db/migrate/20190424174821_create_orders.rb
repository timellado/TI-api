class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.int :Id_o
      t.string :Sku
      t.integer :Cantidad
      t.string :Almacen_id
      t.boolean :Aceptado
      t.boolean :Despachado
      t.integer :Precio

      t.timestamps
    end
  end
end

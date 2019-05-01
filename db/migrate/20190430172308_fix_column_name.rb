class FixColumnName < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :Id_o
    rename_column :orders, :Sku, :sku
    rename_column :orders, :Cantidad, :cantidad
    rename_column :orders, :Almacen_id, :almacenId
    rename_column :orders, :Aceptado, :aceptado
    rename_column :orders, :Despachado, :despachado
    rename_column :orders, :Precio, :precio
  end
end

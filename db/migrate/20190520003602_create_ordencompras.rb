class CreateOrdencompras < ActiveRecord::Migration[5.1]
  def change
    create_table :ordencompras do |t|
      t.string :sku
      t.string :cliente
      t.string :oc_id
      t.string :fechaEntrega
      t.integer :cantidad
      t.string :estado

      t.timestamps
    end
  end
end

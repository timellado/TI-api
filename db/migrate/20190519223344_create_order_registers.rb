class CreateOrderRegisters < ActiveRecord::Migration[5.1]
  def change
    create_table :order_registers do |t|
      t.string :sku
      t.integer :cantidad
      t.datetime :fecha_llegada

      t.timestamps
    end
  end
end

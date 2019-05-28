class AddOcToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :oc, :string
  end
end

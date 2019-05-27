class AddTipoProduccionToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :tipo_produccion, :string
  end
end

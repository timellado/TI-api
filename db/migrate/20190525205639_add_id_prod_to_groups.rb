class AddIdProdToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :id_prod, :string
  end
end

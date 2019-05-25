class AddIdDevToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :id_dev, :string
  end
end

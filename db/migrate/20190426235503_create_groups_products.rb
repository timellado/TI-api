class CreateGroupsProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :groups_products do |t|
      t.references :group, foreign_key: true
      t.references :product, foreign_key: true
    end
  end
end

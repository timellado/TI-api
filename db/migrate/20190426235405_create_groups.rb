class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.integer :grupo

      t.timestamps
    end
  end
end

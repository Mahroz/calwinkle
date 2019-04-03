class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.string :image

      t.timestamps
    end
  end
end

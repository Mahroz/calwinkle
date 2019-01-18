class CreateEvent < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :address
      t.string :occurance
      t.time :start_time
      t.time :end_time
      t.date :start_date
      t.date :end_date
      t.string :main_picture

      t.timestamps
    end
  end
end

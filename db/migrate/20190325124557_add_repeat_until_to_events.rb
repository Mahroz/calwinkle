class AddRepeatUntilToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :repeat_until, :date
  end
end

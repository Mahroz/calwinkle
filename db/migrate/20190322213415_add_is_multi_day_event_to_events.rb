class AddIsMultiDayEventToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :is_multi_day_event, :boolean
  end
end

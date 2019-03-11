class CreateEventCalendars < ActiveRecord::Migration[5.2]
  def change
    create_table :event_calendars do |t|
      t.integer :user_id
      t.text :calendar_html

      t.timestamps
    end
  end
end

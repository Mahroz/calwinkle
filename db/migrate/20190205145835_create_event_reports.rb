class CreateEventReports < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :viewer_count

    create_table :event_reports do |t|
      t.references  :event, index: true
      t.integer     :viewer_count, default: 0
      t.integer     :subscriber_count, default: 0
    end
  end
end

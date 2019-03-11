class AddFieldsForEventCustomRepetition < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :custom_occurance_every_duration, :integer
    add_column :events, :custom_occurance_every_duration_type, :string
    add_column :events, :custom_occurance_weekly_selected_days, :text, array: true, default: []
    add_column :events, :custom_occurance_monthly_at, :date
    add_column :events, :custom_occurance_repeat_ends_at, :date
  end
end

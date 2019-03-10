class AddCustomOccuranceEndsAfterDurationToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :custom_occurance_ends_after_duration, :integer
  end
end

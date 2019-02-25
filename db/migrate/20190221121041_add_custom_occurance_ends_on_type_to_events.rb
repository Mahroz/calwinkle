class AddCustomOccuranceEndsOnTypeToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :custom_occurance_ends_on_type, :string
  end
end

class AddCustomOccuranceMonthlySubTypeToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :custom_occurance_monthly_sub_type, :string
  end
end

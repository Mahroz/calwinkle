class AddOccuranceRuleInEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :occurance
    add_column :events, :occurance_rule, :string
    add_column :events, :occurance_type, :integer
  end
end

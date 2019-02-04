class AddCancelInEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :is_cancel, :boolean, default: false
  end
end

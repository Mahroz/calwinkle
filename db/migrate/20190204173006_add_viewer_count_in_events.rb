class AddViewerCountInEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :viewer_count, :integer, default: 0
  end
end

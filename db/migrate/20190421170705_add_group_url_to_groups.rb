class AddGroupUrlToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :group_url, :string
  end
end

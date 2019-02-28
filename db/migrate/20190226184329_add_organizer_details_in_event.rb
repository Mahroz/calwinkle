class AddOrganizerDetailsInEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :organizer_name, :string, default: nil
    add_column :events, :organizer_phone, :string, default: nil
    add_column :events, :organizer_email, :string, default: nil
    add_column :events, :organizer_website, :string, default: nil
    add_column :events, :organizer_picture, :string, default: nil
  end
end
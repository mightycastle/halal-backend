class AddTextToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :text_title, :string
    add_column :photos, :text_content, :text
    add_column :admin_photos, :text_title, :string
    add_column :admin_photos, :text_content, :text
  end
end

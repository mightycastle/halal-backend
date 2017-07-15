class AddHyperlinkToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :text_hyperlink, :string
    add_column :admin_photos, :text_hyperlink, :string
  end
end

class AddPageUidToBasicPage < ActiveRecord::Migration
  def up
  	add_column :basics_pages, :page_uid, :string
  end
  
  def down
  	remove_column :basics_pages, :page_uid
  end
end

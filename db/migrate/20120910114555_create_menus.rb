class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.string :menu_uid
      t.string :menu_name

      t.timestamps
    end
  end
end

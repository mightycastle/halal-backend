class AddMenuToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :menu_uid,  :string
    add_column :restaurants, :menu_name, :string
  end
end

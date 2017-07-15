class AddDirectionToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :direction, :text
  end
end

class AddRestaurantTempIdToPhoto < ActiveRecord::Migration
  def change
    add_column :photos , :restaurant_temp_id, :integer
  end
end

class AddRestaurantTempIdToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules , :restaurant_temp_id, :integer

  end
end

class CreateFiltersRestaurantTemps < ActiveRecord::Migration
  def up
    create_table :filters_restaurant_temps, :id => false  do |t|
      t.integer :filter_id
      t.integer :restaurant_temp_id

      t.timestamps
    end
  end

  def down
  end
end

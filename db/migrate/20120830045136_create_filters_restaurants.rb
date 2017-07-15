class CreateFiltersRestaurants < ActiveRecord::Migration
  def change
    create_table :filters_restaurants, :id => false  do |t|
      t.integer :filter_id
      t.integer :restaurant_id

      t.timestamps
    end
  end
end

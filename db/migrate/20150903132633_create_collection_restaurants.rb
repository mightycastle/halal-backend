class CreateCollectionRestaurants < ActiveRecord::Migration
  def up
		create_table :collection_restaurants do |t|
			t.integer :collection_id
			t.integer :restaurant_id
			t.integer :order
		end
  end

  def down
		drop_table :collection_restaurants
  end
end

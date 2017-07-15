class CreateGiftcardRestaurantMemberships < ActiveRecord::Migration
  def up
		create_table :giftcard_restaurant_memberships do |t|
			t.integer :restaurant_id
		end
  end

  def down
		drop_table :giftcard_restaurant_memberships
  end
end

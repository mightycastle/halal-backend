class AddIntegramLinkToRestaurantTemp < ActiveRecord::Migration
  def change
    add_column :restaurant_temps, :instagram_link, :string
  end
end

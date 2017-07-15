class AddSugguestEmailToRestaurantTemp < ActiveRecord::Migration
  def change
    add_column :restaurant_temps, :suggester_email, :string
    add_column :restaurant_temps, :suggester_phone, :string
  end
end

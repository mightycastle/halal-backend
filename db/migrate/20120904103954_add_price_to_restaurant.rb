class AddPriceToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :price, :decimal, :default => 0
  end
end

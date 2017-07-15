class AddShortAddressToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :short_address, :string
  end
end

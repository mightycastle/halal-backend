class AddInstagramToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :instagram_link, :string
  end
end

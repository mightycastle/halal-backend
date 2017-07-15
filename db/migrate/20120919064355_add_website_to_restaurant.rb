class AddWebsiteToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :website, :string
    add_column :restaurants, :halal_status, :text
  end
end

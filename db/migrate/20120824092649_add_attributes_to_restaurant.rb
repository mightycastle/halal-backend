class AddAttributesToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :lat, :decimal, :precision => 16, :scale => 13
    add_column :restaurants, :lng, :decimal, :precision => 16, :scale => 13
    add_column :restaurants, :district, :string
    add_column :restaurants, :city, :string
    add_column :restaurants, :postcode, :string
    add_column :restaurants, :country, :string
  end
end

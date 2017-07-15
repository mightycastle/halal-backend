class AddSpecialDealToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :special_deal, :text
  end
end

class AddRatingToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :service_avg, :float, default: 0
    add_column :restaurants, :quality_avg, :float, default: 0
    add_column :restaurants, :value_avg, :float, default: 0
    add_column :restaurants, :rating_avg, :float, default: 0
  end
end

class AddRequestToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :request_approve_photo ,:boolean, :default => false
  end
end

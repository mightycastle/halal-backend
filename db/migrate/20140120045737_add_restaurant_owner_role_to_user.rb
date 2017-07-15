class AddRestaurantOwnerRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :restaurant_owner_role, :boolean, :default => false
  end
end

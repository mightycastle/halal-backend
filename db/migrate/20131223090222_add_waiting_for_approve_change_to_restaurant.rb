class AddWaitingForApproveChangeToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :waiting_for_approve_change, :boolean, :default => false
  end
end

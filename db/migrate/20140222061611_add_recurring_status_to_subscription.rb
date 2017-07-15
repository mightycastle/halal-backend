class AddRecurringStatusToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :recurring_status, :boolean, :default => true
    add_column :subscriptions , :account_id, :string
  end
end

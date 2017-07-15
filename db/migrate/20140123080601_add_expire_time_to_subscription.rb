class AddExpireTimeToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :expire_time, :datetime
  end
end

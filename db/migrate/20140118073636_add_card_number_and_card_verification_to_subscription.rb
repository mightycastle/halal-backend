class AddCardNumberAndCardVerificationToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :card_number, :integer
    add_column :subscriptions, :card_verification, :integer
  end
end

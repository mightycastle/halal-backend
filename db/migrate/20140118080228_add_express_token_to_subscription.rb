class AddExpressTokenToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :express_token, :string
    add_column :subscriptions, :express_payer_id, :string
  end
end

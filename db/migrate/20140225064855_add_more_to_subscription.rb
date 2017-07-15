class AddMoreToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions , :transaction_id, :string
    add_column :subscriptions , :profile_id , :string

  end
end

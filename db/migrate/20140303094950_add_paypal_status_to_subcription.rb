class AddPaypalStatusToSubcription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :paypal_status, :integer
  end
end

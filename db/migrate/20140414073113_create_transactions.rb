class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :subscription_id
      t.string :transaction_id 
      t.text :transaction_data
      t.string :amount
      t.datetime :next_billing_cycle
      t.integer :transaction_status
      t.timestamps
    end
  end
end

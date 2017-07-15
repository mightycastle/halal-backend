class CreateGiftcardRedemptions < ActiveRecord::Migration
  def up
    create_table :giftcard_redemptions do |t|
      t.integer :restaurant_id
      t.integer :giftcard_id
      t.integer :pounds
      t.integer :pence
      t.boolean :deleted
      t.timestamps
    end
  end

  def down
    drop_table :giftcard_redemptions
  end

end

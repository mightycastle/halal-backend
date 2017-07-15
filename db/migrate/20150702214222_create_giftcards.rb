class CreateGiftcards < ActiveRecord::Migration
  def up
    create_table :giftcards do |t|
      t.string :code
      t.integer :pounds
      t.integer :pence
      t.timestamps
    end
  end

  def down
    drop_table :giftcards
  end
end

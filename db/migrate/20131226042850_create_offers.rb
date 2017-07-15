class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.text :offer_content 
      t.integer :restaurant_id
      t.integer :time_available
      t.integer :time_start_offer
      
      t.timestamps 
    end
  end
end

class CreateRestaurantTemps < ActiveRecord::Migration
  def change
    create_table :restaurant_temps do |t|
      t.string :name
      t.string :address
      t.text :description
      t.string :phone
      t.string :email
      t.integer :user_id
      t.boolean :deliverable
      t.boolean :shisha_allow
      t.boolean :disabled, default: false
      t.decimal :price, :default => 0
      t.string :website
      t.text :halal_status
      t.text :special_deal
      t.decimal :lat , :precision => 16, :scale => 13
      t.decimal :lng , :precision => 16, :scale => 13
      t.string :district
      t.string :city
      t.string :postcode
      t.string :country
      t.string :short_address
      t.string :contact_note
      t.string :suggester_name
      t.boolean :is_owner
      t.string :facebook_link
      t.string :twitter_link
      t.string :pinterest_link
      t.integer :restaurant_id
      t.string :slug
      t.string :direction
      t.timestamps

    end
  end
end

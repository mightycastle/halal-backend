class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.text :description
      t.string :phone
      t.string :email
      t.integer :user_id
      t.boolean :deliverable
      t.boolean :shisha_allow
      t.boolean :disabled, default: false
      
      t.timestamps
    end
  end
end

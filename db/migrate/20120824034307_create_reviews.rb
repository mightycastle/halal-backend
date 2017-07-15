class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.string :title
      t.text :content
      t.integer :service
      t.integer :quality
      t.integer :value
      t.boolean :status
      t.integer :rating

      t.timestamps
    end
  end
end

class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :restaurant_id
      t.integer :user_id
      t.boolean :cover, default: false
      t.string :image_uid
      t.string :image_name

      t.timestamps
    end
  end
end

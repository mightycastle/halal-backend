class CreateAdminPhotos < ActiveRecord::Migration
  def change
    create_table :admin_photos do |t|
      t.integer :user_id
      t.boolean :cover, default: false
      t.string :image_uid
      t.string :image_name

      t.timestamps
    end
  end
end

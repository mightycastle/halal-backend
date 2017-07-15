class CreateCollectionImages < ActiveRecord::Migration
  def up
    create_table :collection_images do |t|
      t.integer :collection_id
      t.string :image_uid
      t.string :image_name
      t.string :text_hyperlink
      t.string :text_title
      t.text :text_content
      t.timestamps
    end
  end

  def down
    drop_table :collection_images
  end
end

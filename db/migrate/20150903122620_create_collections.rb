class CreateCollections < ActiveRecord::Migration
  def up
		create_table :collections do |t|
			t.string :name
			t.text :description
			t.string :image_url
			t.timestamps
		end
  end

  def down
		drop_table :collections
  end
end

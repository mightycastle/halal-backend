class CreateBasicsPages < ActiveRecord::Migration
  def change
    create_table :basics_pages do |t|
      t.integer :id
      t.string :page_name
      t.text :page_content

      t.timestamps
    end
  end
end

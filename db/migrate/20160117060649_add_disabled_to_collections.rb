class AddDisabledToCollections < ActiveRecord::Migration
  def up
  	add_column :collections, :disabled, :boolean
  end

  def down
  	remove_column :collections, :disabled
  end
end

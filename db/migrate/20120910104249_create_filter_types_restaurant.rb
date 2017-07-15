class CreateFilterTypesRestaurant < ActiveRecord::Migration
  def change
    create_table :filter_types_restaurants, :id => false  do |t|
      t.integer :filter_type_id
      t.integer :restaurant_id

      t.timestamps
    end
    add_column :filters, :filter_type_id, :integer
  end
end

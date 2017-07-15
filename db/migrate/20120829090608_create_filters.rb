class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :code
      t.string :name
      t.text :description
      t.boolean :status, :default=>true
      t.timestamps
    end
  end
end

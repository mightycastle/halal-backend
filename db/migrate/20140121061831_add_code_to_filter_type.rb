class AddCodeToFilterType < ActiveRecord::Migration
  def change
    add_column :filter_types, :code, :string
  end
end

class AddIndexToFilterType < ActiveRecord::Migration
  def change
    add_column :filter_types , :index_order, :integer
  end
end

class AddIndexOrderToFilters < ActiveRecord::Migration
  def change
    add_column :filters, :index_order, :integer, :default => 99
  end
end

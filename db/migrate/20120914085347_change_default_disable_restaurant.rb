class ChangeDefaultDisableRestaurant < ActiveRecord::Migration
  def change
    change_column :restaurants, :disabled, :boolean, :default => nil
    add_column :restaurants, :is_owner, :boolean
    add_column :restaurants, :contact_note, :string
    add_column :restaurants, :suggester_name, :string
  end
end

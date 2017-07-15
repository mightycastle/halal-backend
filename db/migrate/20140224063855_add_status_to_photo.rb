class AddStatusToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :status, :integer, default: 0
  end
end

class AddOwnerHasReadToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :owner_has_read, :boolean, default: false
  end
end

class AddSatisfiedToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :satisfied, :boolean
  end
end

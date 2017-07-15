class AddVisitedDateToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :visited_date, :date
    add_column :reviews, :terms_conditions, :boolean
  end
end

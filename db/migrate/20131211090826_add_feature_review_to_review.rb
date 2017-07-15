class AddFeatureReviewToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :feature_review, :boolean, :default => false
    add_column :reviews, :feature_review_set_at, :date
  end
end

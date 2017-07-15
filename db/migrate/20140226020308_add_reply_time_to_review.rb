class AddReplyTimeToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :reply_time, :datetime
  end
end

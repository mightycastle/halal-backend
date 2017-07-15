class AddReplyContentUserReplyToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :reply_content, :text
    add_column :reviews, :user_reply, :integer
  end
end

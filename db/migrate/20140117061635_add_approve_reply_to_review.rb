class AddApproveReplyToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :approve_reply, :boolean
  end
end

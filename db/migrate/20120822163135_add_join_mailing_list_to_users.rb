class AddJoinMailingListToUsers < ActiveRecord::Migration
  def change
    add_column :users, :join_mailing_list, :boolean
  end
end

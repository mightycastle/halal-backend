class AddApproveToOffer < ActiveRecord::Migration
  def up
    add_column :offers, :approve , :boolean, :default => false
    add_column :offers, :reject, :boolean, :default => false
  end

end

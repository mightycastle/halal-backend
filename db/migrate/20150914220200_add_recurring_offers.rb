class AddRecurringOffers < ActiveRecord::Migration
  def up
    add_column :offers, :is_onetime, :boolean, default: false
  end

  def down
    remove_column :offers, :is_onetime
  end
end

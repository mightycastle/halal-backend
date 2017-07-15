class ChangeFormatInOffer < ActiveRecord::Migration
  def up
    change_column :offers, :time_available, :string
    change_column :offers, :time_start_offer, :string
    remove_column :offers, :start_day
    add_column :offers, :start_date, :integer
    remove_column :offers, :end_day
    add_column :offers, :end_date, :integer
    change_column :offers, :start_time, :integer
    change_column :offers, :end_time, :integer
  end

  def down
  end
end

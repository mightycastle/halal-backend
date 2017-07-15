class AddStartdayEnddayStarttimeEndtimeToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :start_day, :text
    add_column :offers, :end_day, :text
    add_column :offers, :start_time, :string
    add_column :offers, :end_time, :string
  end
end

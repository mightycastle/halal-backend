class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :restaurant_id
      t.integer :day_of_week
      t.integer :time_open
      t.integer :time_closed

      t.timestamps
    end
  end
end

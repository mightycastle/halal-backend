class AddScheduleTypeToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :schedule_type, :string, :default => 'daily'
  end
end

FactoryGirl.define do
  factory :schedule, :class => Schedule do  |f|    
    f.restaurant_id 0
    f.restaurant_temp_id 0
    f.day_of_week 1
    f.time_open 600
    f.time_closed  1100
    f.created_at Time.now
    f.updated_at Time.now
    f.schedule_type "daily"
  end
end
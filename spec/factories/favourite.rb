FactoryGirl.define do
  factory :favourite, :class => Favourite do  |f|
    f.user_id 0
    f.restaurant_id 0
    f.created_at Time.now
    f.updated_at Time.now
  end
end
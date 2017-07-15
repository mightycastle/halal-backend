FactoryGirl.define do
  factory :menu, :class => Menu do  |f|
    f.user_id 0
    f.restaurant_id 0
    f.menu_name {Faker::Name.name}
    f.name {Faker::Name.name}
    f.created_at Time.now
    f.updated_at Time.now
  end
end
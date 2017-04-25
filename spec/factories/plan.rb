FactoryGirl.define do
  factory :plan, :class => Plan do  |f|
    f.name {Faker::Name.first_name}
    f.amount 100
    f.plan_type_id 0
  end
end
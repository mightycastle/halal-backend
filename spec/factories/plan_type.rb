FactoryGirl.define do
  factory :plan_type, :class => PlanType do  |f|
    f.name {Faker::Name.first_name}
    f.number_of_months 1
  end
end
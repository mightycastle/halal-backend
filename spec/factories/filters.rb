FactoryGirl.define do
  factory :filter, :class => Filter do  |f|
    f.code {Faker::Code.ean}
    f.name {Faker::Name.name}
    f.description {Faker::Lorem.sentence(3)}
    f.filter_type_id 1
  end

  
end




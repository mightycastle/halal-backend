FactoryGirl.define do
  factory :user, :class => User do  |f|
    f.email {Faker::Internet.email}
    f.first_name {Faker::Name.first_name}
    f.last_name {Faker::Name.last_name}
    f.password 12345678
    f.username {Faker::Internet.user_name}
    f.phone {Faker::Number.number(10)}
    f.address {Faker::Address.street_address}
    f.postcode {Faker::Address.postcode}
    f.status {'verified'}
    f.restaurant_owner_role true
    f.is_subscribed false
  end
end
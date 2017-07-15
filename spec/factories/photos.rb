FactoryGirl.define do
  factory :photo, :class => Photo do  |f|
    f.text_title {Faker::Lorem.sentence(3)}
    f.text_content {Faker::Lorem.sentence(3)}
    f.text_hyperlink {Faker::Internet.url}
  end
end
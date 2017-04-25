FactoryGirl.define do
  factory :admin_photo, :class => AdminPhoto do  |f|
    f.text_title {Faker::Lorem.sentence(3)}
    f.text_content {Faker::Lorem.sentence(3)}
    f.text_hyperlink {Faker::Internet.url}
  end
end
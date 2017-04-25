FactoryGirl.define do
  factory :offer, :class => Offer do  |f|    
    f.offer_content     Faker::Name.name
    f.time_start_offer  Time.now
    f.start_time        1200
    f.end_time          1600
    f.start_date        1
    f.end_date          5
    f.approve           false
    f.reject            false
  end
end
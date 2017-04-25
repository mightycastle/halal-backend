FactoryGirl.define do
  factory :restaurant, :class => Restaurant do  |f|  
    f.user_id 0
    f.menu_uid 0
    f.slug "#{Faker::Name.name}#{Time.now.to_i}"
    f.name {Faker::Name.name}
    f.address {Faker::Address.street_address}
    f.description 'Description'
    f.phone Faker::Number.number(10)
    f.email { Faker::Internet.email }
    f.deliverable true
    f.shisha_allow true
    f.disabled false
    f.created_at Time.now
    f.updated_at Time.now
    f.lat 10.7717395
    f.lng 106.669815
    f.district Faker::Address.street_address
    f.city {Faker::Address.city}
    f.postcode {Faker::Address.postcode}
    f.country {Faker::Address.country}
    f.direction 'abc'
    f.service_avg 0
    f.quality_avg 0
    f.value_avg 0
    f.rating_avg 0
    f.price Faker::Commerce.price
    f.menu_name 'Menu name'
    f.is_owner true
    f.contact_note 'Contact note'
    f.suggester_name 'Suggester name'
    f.website "google.com"
    f.halal_status "Normal"
    f.short_address {Faker::Address.street_address}
    f.special_deal "Special deal"
    f.facebook_link "facebook.com"
    f.twitter_link "twitter.com"
    f.pinterest_link "pinterest_link"
    f.waiting_for_approve_change true
    f.suggester_email "abc#{Time.now.to_i}@gmail.com"
    f.suggester_phone {Faker::PhoneNumber.cell_phone}
    f.request_approve_photo true
    f.instagram_link "instagram.com"
  end
end
     
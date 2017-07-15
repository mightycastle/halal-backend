FactoryGirl.define do
  factory :subscription, :class => Subscription do  |f|    
    f.user_id 0
    f.ip_address {Faker::Internet.ip_v4_address}
    f.first_name {Faker::Name.first_name}
    f.last_name {Faker::Name.last_name}
    f.card_type {Faker::Business.credit_card_type}
    f.card_expires_on {Faker::Business.credit_card_expiry_date}
    f.card_number {Faker::Business.credit_card_number}

    f.action "string"
    f.amount 20
    f.success true
    f.authorization "1231adawdawawe123"
    f.message "Success subscription"
    f.params ""
    f.card_verification "1231adawdawawe123"
    f.express_token "1231adawdawawe123"
    f.express_payer_id "1231adawdawawe123"
    f.plan_id 1
    f.expire_time (Time.now + 1.year)
    f.recurring_status true
    f.account_id "1231adawdawawe123"
    f.transaction_id "1231adawdawawe123"
    f.profile_id "1231adawdawawe123"
    f.paypal_status 1
  end
end
FactoryGirl.define do
  factory :transaction, :class => Transaction do  |f|    
    f.transaction_id 1
    f.subscription_id 1
    f.transaction_data 'qwerty'
    f.amount 100
    f.next_billing_cycle {Time.now + 10.days}
    f.transaction_status true
  end
end
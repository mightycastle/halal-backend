require "rails_helper"

describe Subscription do
  
  it "belongs to user" do
    Subscription.reflect_on_association(:user).macro.should eq(:belongs_to)
  end
  
  it "belongs to plan" do
    Subscription.reflect_on_association(:plan).macro.should eq(:belongs_to)
  end
  
  it "has many to transactions" do
    Subscription.reflect_on_association(:transactions).macro.should eq(:has_many)
  end
  
end
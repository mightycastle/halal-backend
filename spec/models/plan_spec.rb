require "rails_helper"

describe Plan do
  
  it "belongs to user" do
    Plan.reflect_on_association(:plan_type).macro.should eq(:belongs_to)
  end

  it "has many restaurant" do
    Plan.reflect_on_association(:subscriptions).macro.should eq(:has_many)
  end
  
end
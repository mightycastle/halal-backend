require "rails_helper"

describe PlanType do
  
  it "has many plans" do
    PlanType.reflect_on_association(:plans).macro.should eq(:has_many)
  end
  
end
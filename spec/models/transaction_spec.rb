require "rails_helper"

describe Transaction do
  
  it "belongs to subscription" do
    Transaction.reflect_on_association(:subscription).macro.should eq(:belongs_to)
  end
  
end
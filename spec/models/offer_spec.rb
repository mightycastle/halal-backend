require "rails_helper"

describe Offer do
  
  it "belongs to restaurant" do
    Offer.reflect_on_association(:restaurant).macro.should   eq(:belongs_to)
  end
  
end
require "rails_helper"

describe Schedule do
  
  it "belongs to restaurant" do
    Schedule.reflect_on_association(:restaurant).macro.should eq(:belongs_to)
  end
  
  it "belongs to restaurant temp" do
    Schedule.reflect_on_association(:restaurant_temp).macro.should eq(:belongs_to)
  end
  
end
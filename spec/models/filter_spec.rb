require "rails_helper"

describe Filter do
  
  it "is invalid without name" do
    FactoryGirl.build(:filter, name: nil).should_not be_valid
  end
  
  it "belongs to filter_type" do
    Filter.reflect_on_association(:filter_type).macro.should eq(:belongs_to)
  end

  it "has and belongs to many restaurant_temps" do
    Filter.reflect_on_association(:restaurants).macro.should eq(:has_and_belongs_to_many)
  end
  
  it "has and belongs to many restaurant_temps" do
    Filter.reflect_on_association(:restaurant_temps).macro.should eq(:has_and_belongs_to_many)
  end
  
end
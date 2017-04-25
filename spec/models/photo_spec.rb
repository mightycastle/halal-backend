require "rails_helper"

describe Photo do
  
  it "is invalid without image" do
    FactoryGirl.build(:photo, image: nil).should_not be_valid
  end

  it "belongs to restaurant" do
    Photo.reflect_on_association(:restaurant).macro.should eq(:belongs_to)
  end
  
  it "belongs to restaurant temp" do
    Photo.reflect_on_association(:restaurant_temp).macro.should eq(:belongs_to)
  end
  
  it "belongs to user" do
    Photo.reflect_on_association(:user).macro.should eq(:belongs_to)
  end
  
end
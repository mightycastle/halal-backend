require "rails_helper"

describe RestaurantTemp do
  
  it "belongs to to user" do
    RestaurantTemp.reflect_on_association(:user).macro.should eq(:belongs_to)
  end
  
  it "has many to user" do
    RestaurantTemp.reflect_on_association(:schedules).macro.should eq(:has_many)
  end
  
  it "has many to user" do
    RestaurantTemp.reflect_on_association(:photos).macro.should eq(:has_many)
  end
  
  it "has and belongs to many to user" do
    RestaurantTemp.reflect_on_association(:filters).macro.should eq(:has_and_belongs_to_many)
  end
  
end
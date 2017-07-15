require "rails_helper"

describe Review do
  
  it "is invalid without content" do
    FactoryGirl.build(:review, content: nil).should be_valid 
  end

  it "is invalid without too long content (more than 5000 characters)" do
    FactoryGirl.build(:review, content: Faker::Lorem.characters(5001)).should_not be_valid 
  end

  it "belongs to user" do
    Review.reflect_on_association(:user).macro.should eq(:belongs_to)
  end
  
  it "belongs to user" do
    Review.reflect_on_association(:restaurant).macro.should eq(:belongs_to)
  end
  
end
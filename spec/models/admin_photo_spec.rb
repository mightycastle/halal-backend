require "rails_helper"

describe AdminPhoto do
  
  it "is invalid without image" do
    FactoryGirl.build(:admin_photo, image: nil).should_not be_valid 
  end

  it "belongs to user" do
    AdminPhoto.reflect_on_association(:user).macro.should   eq(:belongs_to)
  end
  
end
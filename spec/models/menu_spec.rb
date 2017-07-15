require "rails_helper"

describe Menu do
  
  it "belongs to restaurant" do
    Menu.reflect_on_association(:restaurant).macro.should eq(:belongs_to)
  end

  it "belongs to user" do
    Menu.reflect_on_association(:user).macro.should eq(:belongs_to)
  end
  
end
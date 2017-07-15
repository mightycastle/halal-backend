require "rails_helper"

describe Favourite do
  
  it "belongs to user" do
    Favourite.reflect_on_association(:user).macro.should eq(:belongs_to)
  end

  it "belongs to restaurant" do
    Favourite.reflect_on_association(:restaurant).macro.should eq(:belongs_to)
  end
  
end
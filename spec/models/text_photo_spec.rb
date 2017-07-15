require "rails_helper"

describe TextPhoto do
  
  it "belongs to photo" do
    TextPhoto.reflect_on_association(:photo).macro.should eq(:belongs_to)
  end
  
end
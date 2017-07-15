require "rails_helper"

describe FilterType do
  
  it "has_many filters" do
    FilterType.reflect_on_association(:filters).macro.should   eq(:has_many)
  end
  
  it "has and belongs to many restaurants" do
    FilterType.reflect_on_association(:restaurants).macro.should   eq(:has_and_belongs_to_many)
  end
  
end
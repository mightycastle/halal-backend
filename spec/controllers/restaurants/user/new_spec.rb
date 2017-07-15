require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")

describe RestaurantsController, "test" do
  context "New action" do
    it "case 1: should render new" do
      get "new"
      assigns[:restaurant].should be_new_record
      response.should render_template('new')
    end    
  end
end
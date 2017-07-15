require 'spec_helper'
require "rails_helper"
describe UsersController, :type => :controller do
  before :each do
    @user1 = create(:user)
    @restaurant = create(:restaurant, {user_id: @user1.id, email: @user1.email})
    @params_share_restaurant_via_email = {
      to: Faker::Internet.email, 
      from: Faker::Internet.email, 
      subject: "Check out this restaurant on HalalGems", 
      message: "I found this restaurant on HalalGems. Lets check it out one day!", 
      url: "http://localhost:3000/#{@restaurant.slug}"
    }
  end

  context "share_restaurant_via_email" do

    it "case 1: no login, call action success" do      
      xhr :post, "share_restaurant_via_email", format: "js", email_pr: @params_share_restaurant_via_email
      assigns[:email].should deliver_to(@params_share_restaurant_via_email[:to])
      assigns[:email].should deliver_from(@params_share_restaurant_via_email[:from])
    end

    it "case 2: login, call action, with none params" do
      xhr :post, "share_restaurant_via_email", format: "js"
      expect(assigns[:email]).to eq nil
    end

    it "case 3: login, call action, with valid params" do
      xhr :post, "share_restaurant_via_email", format: "js", email_pr: @params_share_restaurant_via_email
      assigns[:email].should deliver_to(@params_share_restaurant_via_email[:to])
      assigns[:email].should deliver_from(@params_share_restaurant_via_email[:from])
    end
    
  end
end




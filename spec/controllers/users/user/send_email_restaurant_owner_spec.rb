require 'spec_helper'
require "rails_helper"

describe UsersController, :type => :controller do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  before :each do
    @user1 = create(:user)
    @restaurant = create(:restaurant, {user_id: @user1.id, email: @user1.email})
    @params_send_email_rest_owner = {
      restaurant_email: @restaurant.email,
      message: "test message 123"
    }
  end

  context "send email restaurant owner" do

    it "case 1: no login, call action, should redirect to sign in page" do      
      xhr :post, "send_email_restaurant_owner", format: "js", user: @params_send_email_rest_owner
      assigns[:email].should eq nil
    end

    it "case 2: login, call action, with none params" do
      sign_in @user1      
      xhr :post, "send_email_restaurant_owner", format: "js"
      expect(assigns[:email]).to eq nil
    end

    it "case 3: login, call action, with valid params" do
      sign_in @user1            
      xhr :post, "send_email_restaurant_owner", format: "js", user: @params_send_email_rest_owner
      assigns[:email].should deliver_to(@restaurant.email)
    end
    
  end
end

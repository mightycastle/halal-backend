require 'spec_helper'
require "rails_helper"
describe UsersController, :type => :controller do
  before :each do
    @user1 = create(:user)
    sign_in @user1
  end

  context "Check user" do
    it "call check user with username of user1" do
      xhr :get, 'check_user', :format => "js", user_name: @user1.username      
      output = JSON.parse(response.body)
      expect(assigns[:user]).to eq @user1
      expect(output[0]["flag"]).to eq true
    end

    it "call check user with username of user1" do
      xhr :get, 'check_user', :format => "js", user_name: "invalid username"
      output = JSON.parse(response.body)
      expect(assigns[:user]).to eq nil
      expect(output[0]["flag"]).to eq false
    end
  end
end

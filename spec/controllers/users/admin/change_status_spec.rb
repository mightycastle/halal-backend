require 'spec_helper'
require "rails_helper"
describe UsersController, "test" do
  before :each do
    @user1 = create(:user, {status: 'verified'})
    @admin = create(:user)
    @admin.update_column(:admin_role, true)  
  end

  context "Change status" do
    it "not login, call action should redirect to sign in page" do
      xhr :post, "change_status", format: 'js', id: @user1.id, status: "closed"
      response.status.should eq 401
    end

    it "login user, call action should redirect to home page" do
      sign_in @user1
      xhr :post, "change_status", format: 'js', id: @user1.id, status: "closed"
      response.should redirect_to("/")
    end

    it "login admin, call action success" do
      sign_in @admin
      xhr :post, "change_status", format: 'js', id: @user1.id, status: "closed"
      expect(assigns[:user].id).to eq @user1.id
      expect(assigns[:user].status).to eq "closed"

      xhr :post, "change_status", format: 'js', id: @user1.id, status: "unverified"
      expect(assigns[:user].id).to eq @user1.id
      expect(assigns[:user].status).to eq "unverified"
    end
  end
end


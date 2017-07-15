require 'spec_helper'
require "rails_helper"
describe UsersController, :type => :controller do
  before :each do
    @user1 = create(:user)
    @user2 = create(:user)
    photo = fixture_file_upload("/images/test.jpg", 'image/jpg')
    @params_update_avatar = {
      avatar: photo
    }
  end

  context "update avatar" do
    it "case 1: not login, call action should redirect to sign in page" do
      xhr :post, 'update_avatar', format: "js", id: @user1.id
      response.status.should eq 401
    end

    it "case 2: login user, call action with other user, should redirect to home page" do
      sign_in @user2
      xhr :post, 'update_avatar', format: "js", id: @user1.id, user: @params_update_avatar
      response.should redirect_to("/")
    end

    it "case 3: login admin, call action should success" do
      sign_in @user1
      xhr :post, 'update_avatar', format: "js", id: @user1.id, user: @params_update_avatar, remotipart_submitted: true, "X-Requested-With"=>"IFrame", "X-Http-Accept"=>"text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01"
      expect(@user1.reload.id).to eq @user1.id
      expect(assigns[:user].errors.blank?).to eq true
      # expect(@user1.avatar.url).to eq "test.jpg"
    end
  end
end
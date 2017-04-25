require 'spec_helper'
require "rails_helper"
require Rails.root.join("spec/helpers/user_helper.rb")
describe UsersController, :type => :controller do
  before :each do
    clear_database
    @user1 = create(:user)
    @user2 = create(:user)
    @admin = create(:user)
    @admin.update_column(:admin_role, true)
  end

  context "Index" do
    it "not login, call action should redirect to sign in page" do
      get 'index'
      response.should redirect_to(new_user_session_path)
    end

    it "login user, call action should redirect to home page" do
      sign_in @user1
      get 'index'
      response.should redirect_to("/")
    end

    it "login admin, call action should render index" do
      sign_in @admin
      get 'index'
      response.should render_template("index")
      expect(assigns[:users].length).to eq 3
    end
  end
end
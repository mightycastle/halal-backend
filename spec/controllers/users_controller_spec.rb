require 'spec_helper'
require "rails_helper"
require Rails.root.join("spec/helpers/user_helper.rb")
describe UsersController, :type => :controller do
  before :each do
    clear_database
  end
  describe "Test UsersController" do
    it "assigns @users" do
      user = create(:user, admin_role: true)
      sign_in user
      get 'index'
      expect(assigns(:users)).to eq([user])
    end

    it "renders the show template" do
    	user = create(:user, admin_role: true)
      sign_in user
      get 'show', id: user.id
      response.should render_template :show
    end


    it "check check_user function" do
    	user = create(:user)
      sign_in user
      @expected = [{ 
	        :flag  => true,
	        :user     => {id: user.id}
				}].to_json
      get 'check_user', user_name: user.username
      response.body.should == @expected
    end

    it "change_status" do
    	user = create(:user, admin_role: true)
    	user2 = create(:user)
      sign_in user
      post "change_status", id: user2.id, status: 'closed', format: 'js'
      user2.reload.status.should eq 'closed'
    end
  end
end
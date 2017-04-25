require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")


describe RestaurantsController, "test" do
  context "New action" do
    before :each do 
      @user1 = create(:user)
      @admin = create(:user)
      @admin.update_column(:admin_role, true)
    end
    it "case 1: not login, redirect to sign in" do
      get "admin_new"
      response.should redirect_to(new_user_session_path)
    end    
    it "case 2: login user, redirect to home page" do
      sign_in @user1
      get "admin_new"
      response.should redirect_to("/")
    end   
    it "case 3: login admin, render template admin new" do
      sign_in @admin
      get "admin_new"
      response.should render_template('admin_new')
      expect(assigns[:restaurant].new_record?).to eq true
      expect(assigns[:restaurant].schedules.length).to eq 7
    end   
  end
end
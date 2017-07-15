require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")


describe RestaurantsController, "test" do
  context "Change photo request" do
    before :each do 
      @user1 = create(:user)
      @admin = create(:user)
      @admin.update_column(:admin_role, true)
      @restaurant = create(:restaurant, {user_id: @user1.id})

    end
    it "case 1: not login, redirect to sign in" do
      get "change_photo_request"
      response.should redirect_to(new_user_session_path)
    end    
    it "case 2: login admin, redirect to home page" do
      sign_in @user1
      get "change_photo_request"
      response.should redirect_to("/")
    end   
    it "case 3: login admin, restaurant not have photo change, render template request photo request" do
      sign_in @admin
      get "change_photo_request"
      response.should render_template('change_photo_request')
      expect(assigns[:restaurants]).not_to include @restaurant
    end   
    it "case 4: login admin, restaurant have photo change, render template request photo request" do
      @photo = request_new_photo_restaurant(@restaurant, @user1, 0)
      sign_in @admin
      get "change_photo_request"
      response.should render_template('change_photo_request')
      expect(assigns[:restaurants]).to include @restaurant
      @photo.update_column(:status, 1)
      get "change_photo_request"
      response.should render_template('change_photo_request')
      expect(assigns[:restaurants]).to include @restaurant
    end   
    
  end
end
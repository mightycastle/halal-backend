require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")
require Rails.root.join("spec/helpers/user_helper.rb")

describe RestaurantsController, "test" do
  before :each do 
    @user1 = create(:user)    
    @user2 = create(:user)    
    @restaurant = create(:restaurant, {user_id: @user1.id})    
  end

  context "New offer action" do
    it "case 1: not login should redirect to sign in" do
      get "offer", id: @restaurant.slug     
      response.should redirect_to(new_user_session_path)
    end    

    it "case 2: login not subscription, should redirect to back" do
      request.env["HTTP_REFERER"] = "/new"
      sign_in @user1
      get "offer", id: @restaurant.slug   
      expect(flash[:notice]).to eq I18n.t('user.require_profession_user')
      response.should redirect_to("/new")
    end       

    it "case 3: login subscription, not owner, should redirect to home page" do
      subscribe_user(@user2)
      sign_in @user2
      get "offer", id: @restaurant.slug     
      response.should redirect_to("/")
    end     

    it "case 4: login subscription, owner, should go to offer" do
      subscribe_user(@user1)
      sign_in @user1
      get "offer", id: @restaurant.slug     
      response.should render_template("offer")
    end         
  end
end
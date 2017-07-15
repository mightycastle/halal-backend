require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")
require Rails.root.join("spec/helpers/user_helper.rb")

describe RestaurantsController, "test" do
  before :each do 
    @user1 = create(:user)    
    @user2 = create(:user)    
    @restaurant = create(:restaurant, {user_id: @user1.id})    
    @params_social_link = {
      facebook_link: "abc.com", 
      twitter_link: "abc1.com", 
      pinterest_link: "abc2.com", 
      instagram_link:"abc3.com"
    }
  end

  context "update social link action" do
    it "case 1: not login should redirect to sign in" do
      xhr :put, "update_social_link", :format => "js", id: @restaurant.slug, restaurant: @params_social_link  
      response.should redirect_to(new_user_session_path)
    end    

    it "case 2: login not subscription, should redirect to back" do
      request.env["HTTP_REFERER"] = "/new"
      sign_in @user1
      xhr :put, "update_social_link", :format => "js", id: @restaurant.slug, restaurant: @params_social_link  
      expect(flash[:notice]).to eq I18n.t('user.require_profession_user')
      response.should redirect_to("/new")
    end       

    it "case 3: login subscription, not owner, should redirect to home page" do
      subscribe_user(@user2)
      sign_in @user2
      xhr :put, "update_social_link", :format => "js", id: @restaurant.slug, restaurant: @params_social_link  
      response.should redirect_to("/")
    end     

    it "case 4: login subscription, owner, should update success" do
      subscribe_user(@user1)
      sign_in @user1
      xhr :put, "update_social_link", :format => "js", id: @restaurant.slug, restaurant: @params_social_link  
      expect(assigns[:restaurant].facebook_link).to eq @params_social_link[:facebook_link]
      expect(assigns[:restaurant].twitter_link).to eq @params_social_link[:twitter_link]
      expect(assigns[:restaurant].pinterest_link).to eq @params_social_link[:pinterest_link]
      expect(assigns[:restaurant].instagram_link).to eq @params_social_link[:instagram_link]
    end         
  end
end
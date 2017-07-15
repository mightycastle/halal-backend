require 'spec_helper'
require "rails_helper"  

describe ReviewsController, :type => :controller do  
  context "admin_review_replies" do  

    before do  
      @user1 = create(:user)
      user2 = create(:user)
      @admin = create(:user, {admin_role: true})
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @review1 = create(:review, {user_id: user2.id, restaurant_id: @restaurant.id, reply_content: "reply review1"})
      @review2 = create(:review, {user_id: user2.id, restaurant_id: @restaurant.id, reply_content: "reply review2"})
      @review3 = create(:review, {user_id: user2.id, restaurant_id: @restaurant.id, reply_content: nil})
    end  
    
    it "case 1: not login, call action, return error" do 
      get :admin_review_replies
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login user, call action, redirect to home page" do 
      sign_in @user1
      get :admin_review_replies
      response.should redirect_to("/")
    end

    it "case 3: login admin, call action with none param restaurant_id" do 
      sign_in @admin
      get :admin_review_replies
      expect(assigns[:reviews]).not_to include @review3
      expect([@review1, @review2] & assigns[:reviews] == [@review1, @review2]).to eq true
    end

  end
end
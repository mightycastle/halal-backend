require 'spec_helper'
require "rails_helper"  

describe ReviewsController, :type => :controller do  
  context "update_review" do  

    before do  
      @user1 = create(:user)
      user2 = create(:user)
      @admin = create(:user, {admin_role: true})
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @review = create(:review, {user_id: user2.id, restaurant_id: @restaurant.id})
      @params_update_review = {
        id: @review.id,
        content: "update review content"
      }
    end  
    
    it "case 1: not login, call action, return error" do 
      post :update_review, review: @params_update_review, :id => @review.id
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login user, call action, redirect to home page" do 
      sign_in @user1
      post :update_review, review: @params_update_review, :id => @review.id
      response.should redirect_to("/")
    end

    it "case 3: login user, call action with none param restaurant_id" do 
      sign_in @admin
      post :update_review, review: @params_update_review, :id => @review.id
      expect(assigns[:review].content).to eq @params_update_review[:content]
      expect(assigns[:review].restaurant_id).to eq @restaurant.id
    end

    it "case 4: login user, call action with param restaurant_id" do 
      sign_in @admin
      restaurant2 = create(:restaurant, {user_id: @user1.id})
      @params_update_review["restaurant_id"] = restaurant2.id
      post :update_review, review: @params_update_review, :id => @review.id
      expect(assigns[:review].content).to eq @params_update_review[:content]
      expect(assigns[:review].restaurant_id).to eq restaurant2.id
    end
  end
end
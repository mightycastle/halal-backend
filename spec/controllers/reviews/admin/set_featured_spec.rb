require 'spec_helper'
require "rails_helper"  

describe ReviewsController, :type => :controller do  
  context "set_feature" do  

    before do  
      @user1 = create(:user)
      @user2 = create(:user, {email: "dieuit07@gmail.com"})
      @admin = create(:user, {admin_role: true})
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @review = create(:review, {user_id: @user2.id, restaurant_id: @restaurant.id, status: 1, feature_review: 0})
    end  
    
    it "case 1: not login, call action, return error" do 
      xhr :post, "set_featured", format: "js", id: @review.id, status: 1
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login user, call action, redirect to home page" do 
      sign_in @user1
      xhr :post, "set_featured", format: "js", id: @review.id, status: 1
      response.should redirect_to("/")
    end

    it "case 3: login admin, call action valid params" do 
      sign_in @admin
      xhr :post, "set_featured", format: "js", id: @review.id, status: 1
      expect(assigns[:review].id).to eq @review.id
      expect(assigns[:review].feature_review).to eq true 
    end

    it "case 4: login admin, call action with params status 0" do 
      sign_in @admin
      xhr :post, "set_featured", format: "js", id: @review.id, status: 0
      expect(assigns[:review].id).to eq @review.id
      expect(assigns[:message]).to eq I18n.t('review.warning_message_feature') 
    end

    it "case 5: login admin, call action fail when restaurant have 3 review featured before" do 
      create(:review, {user_id: @user2.id, restaurant_id: @restaurant.id, status: 1, feature_review: 1})
      create(:review, {user_id: @user2.id, restaurant_id: @restaurant.id, status: 1, feature_review: 1})
      create(:review, {user_id: @user2.id, restaurant_id: @restaurant.id, status: 1, feature_review: 1})
      sign_in @admin
      xhr :post, "set_featured", format: "js", id: @review.id, status: 1
      expect(assigns[:review].id).to eq @review.id
      expect(assigns[:message]).to eq I18n.t('review.warning_message_feature') 
    end

  end
end
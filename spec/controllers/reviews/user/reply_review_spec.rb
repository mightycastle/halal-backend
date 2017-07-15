require 'spec_helper'
require "rails_helper"  

describe ReviewsController, :type => :controller do  
  context "reply_review" do  

    before do  
      @user1 = create(:user)
      @user2 = create(:user, {email: "dieuit07@gmail.com"})
      @admin = create(:user, {admin_role: true})
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @review = create(:review, {user_id: @user2.id, restaurant_id: @restaurant.id, status: 1})
      @reply_content = "reply content"
    end  
    
    it "case 1: not login, call action, redirect to sign in" do 
      xhr :post, "reply_review", format: "js", "reply_review"=>{"reply_content"=>@reply_content}, "review_id"=>@review.id
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login user not owner, call action, redirect to home page" do 
      sign_in @user2
      xhr :post, "reply_review", format: "js", "reply_review"=>{"reply_content"=>@reply_content}, "review_id"=>@review.id
      expect(@review.reload.reply_content).not_to eq @reply_content
    end

    it "case 3: login owner, call action with valid params" do 
      sign_in @user1
      xhr :post, "reply_review", format: "js", "reply_review"=>{"reply_content"=>@reply_content}, "review_id"=>@review.id
      expect(@review.reload.reply_content).to eq @reply_content
    end

    it "case 4: login owner, call action with invalid review_id" do 
      sign_in @user1
      xhr :post, "reply_review", format: "js", "reply_review"=>{"reply_content"=>@reply_content}, "review_id"=>9999999
      expect(@review.reload.reply_content).not_to eq @reply_content
    end

  end
end
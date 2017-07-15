require 'spec_helper'
require "rails_helper"  

describe ReviewsController, :type => :controller do  
  context "update_reply_content" do  

    before do  
      @user1 = create(:user)
      @user2 = create(:user, {email: "dieuit07@gmail.com"})
      @admin = create(:user, {admin_role: true})
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @review = create(:review, {user_reply: @user1.id, user_id: @user2.id, restaurant_id: @restaurant.id, status: 0})
    end  
    
    it "case 1: not login, call action, return error" do 
      xhr :post, "update_reply_content", format: "js", id: @review.id, reply_content: "update reply 123"
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login user, call action, redirect to home page" do 
      sign_in @user1
      xhr :post, "update_reply_content", format: "js", id: @review.id, reply_content: "update reply 123"
      response.should redirect_to("/")
    end

    it "case 3: login user, call action with none param restaurant_id" do 
      sign_in @admin
      xhr :post, "update_reply_content", format: "js", id: @review.id, reply_content: "update reply 123"
      expect(assigns[:review].reply_content).to eq "update reply 123"
    end

  end
end
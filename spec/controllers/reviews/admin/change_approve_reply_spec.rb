require 'spec_helper'
require "rails_helper"  

describe ReviewsController, :type => :controller do  
  context "change_approve_reply" do  

    before do  
      @user1 = create(:user, {email: "dieuit07@gmail.com"})
      user2 = create(:user)
      @admin = create(:user, {admin_role: true})
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @review1 = create(:review, {user_reply: @user1.id, user_id: user2.id, restaurant_id: @restaurant.id, reply_content: "reply review1"})
    end  
    
    it "case 1: not login, call action, return error" do 
      xhr :post, "change_approve_reply", format: "js", id: @review1.id, approve_reply: 1
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login user, call action, redirect to home page" do 
      sign_in @user1
      xhr :post, "change_approve_reply", format: "js", id: @review1.id, approve_reply: 1
      response.should redirect_to("/")
    end

    it "case 3: login admin, call action success" do 
      sign_in @admin
      xhr :post, "change_approve_reply", format: "js", id: @review1.id, approve_reply: 1
      expect(assigns[:review].approve_reply).to eq true
      
      xhr :post, "change_approve_reply", format: "js", id: @review1.id, approve_reply: 0
      expect(assigns[:review].approve_reply).to eq false
      assigns[:email].should deliver_to(@user1.email)

      xhr :post, "change_approve_reply", format: "js", id: @review1.id, approve_reply: 1
      expect(assigns[:review].approve_reply).to eq true
    end

  end
end
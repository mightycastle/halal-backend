require 'spec_helper'
require "rails_helper"  

describe ReviewsController, :type => :controller do  
  context "change_status" do  

    before do  
      @user1 = create(:user)
      @user2 = create(:user, {email: "dieuit07@gmail.com"})
      @admin = create(:user, {admin_role: true})
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @review = create(:review, {user_id: @user2.id, restaurant_id: @restaurant.id, status: 0})
    end  
    
    it "case 1: not login, call action, return error" do 
      xhr :post, "change_status", format: "js", id: @review.id, status: 1
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login user, call action, redirect to home page" do 
      sign_in @user1
      xhr :post, "change_status", format: "js", id: @review.id, status: 1
      response.should redirect_to("/")
    end

    it "case 3: login user, call action with none param restaurant_id" do 
      sign_in @admin
      xhr :post, "change_status", format: "js", id: @review.id, status: 1
      expect(assigns[:review].status).to eq true
      
      xhr :post, "change_status", format: "js", id: @review.id, status: 0
      expect(assigns[:review].status).to eq false
      assigns[:email].should deliver_to(@user2.email)

      xhr :post, "change_status", format: "js", id: @review.id, status: 1
      expect(assigns[:review].status).to eq true
    end

  end
end
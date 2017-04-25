require 'spec_helper'
require "rails_helper"

describe OffersController, :type => :controller do
  context "Test Offer reject" do
    before :each do
      @user = create(:user, admin_role: true)
      @restaurant = create(:restaurant, user_id: @user.id)
      @offer = create(:offer, restaurant_id: @restaurant.id)
      sign_in @user
    end

    it "Invalid offer id" do
      post 'reject', id: 9999
      expect(assigns(:offer)).to be_nil
    end
    
    it "All valid" do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      post 'reject', id: @offer.id
      result_offer = assigns(:offer)
      expect(result_offer).to be_truthy
      expect(result_offer.approve).to be false
      expect(result_offer.reject).to be true
      ActionMailer::Base.deliveries.first.subject.should == "Your restaurant's offer has rejected by admin."
    end
    it "All valid but user not admin role" do
      @user.update_attribute('admin_role', false)
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      post 'reject', id: @offer.id
      result_offer = assigns(:offer)
      expect(result_offer).to eq nil
    end
  end
end
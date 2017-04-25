require 'spec_helper'
require "rails_helper"

describe OffersController, :type => :controller do
  context "Test Offer approve" do
    before :each do
      @user = create(:user, admin_role: true)
      @offer = create(:offer)
      sign_in @user
    end

    it "Invalid offer id" do
      post 'approve', id: 9999
      expect(assigns(:offer)).to be_nil
    end
    
    it "All valid" do
      post 'approve', id: @offer.id
      result_offer = assigns(:offer)
      expect(result_offer).to be_truthy
      expect(result_offer.approve).to be true
      expect(result_offer.reject).to be false
    end
    it "ALl valid offer id but user is not admin role" do
       @user.update_attribute('admin_role', false)
      post 'approve', id: @offer.id
      expect(assigns(:offer)).to be_nil
    end
  end
end
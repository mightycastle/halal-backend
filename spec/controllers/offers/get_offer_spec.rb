require 'spec_helper'
require "rails_helper"

describe OffersController, :type => :controller do
  context "Test Offer get offer" do
    before :each do
      @user = create(:user)
      @offer = create(:offer)
      sign_in @user
    end

    it "Invalid offer id" do
      get 'get_offer', id: 9999
      expect(assigns(:offer)).to be_nil
    end
    
    it "All valid" do
      get 'get_offer', id: @offer.id
      result_offer = assigns(:offer)
      expect(result_offer).to be_truthy
      expect(result_offer.offer_content).to    eq @offer.offer_content
      expect(result_offer.start_time).to       eq @offer.start_time
      expect(result_offer.end_time).to         eq @offer.end_time
      expect(result_offer.start_date).to       eq @offer.start_date
      expect(result_offer.end_date).to         eq @offer.end_date
      expect(result_offer.approve).to          eq @offer.approve
      expect(result_offer.reject).to           eq @offer.reject
    end
    
  end
end
require 'spec_helper'
require "rails_helper"

describe OffersController, :type => :controller do
  context "Test Offer get offer image" do
    before :each do
      @user = create(:user, restaurant_owner_role: true  )
      @restaurant = create(:restaurant, user_id: @user.id)
      @offer = create(:offer, restaurant_id: @restaurant.id)
      sign_in @user
    end

    it "update offer find by offer id" do
      create_offer_params = {
        "id"                => @offer.id,
        "offer_content"     => @offer.offer_content,
        "time_start_offer"  => @offer.time_start_offer,
        "start_time"        => @offer.start_time,
        "end_time"          => @offer.end_time,
        "start_date"        => @offer.start_date,
        "end_date"          => @offer.end_date
      }

      post 'create', offer: create_offer_params
      result_offer = assigns(:offer)
      expect(result_offer).to be_truthy
      response.should redirect_to(offer_restaurant_path(@restaurant.slug))
    end
    
    it "create offer with params offer" do
      create_offer_params = {
        "offer_content"    => Faker::Name.name,
        "time_start_offer" => Time.now,
        "start_time"       => 1200,
        "end_time"         => 1600,
        "start_date"       => 1,
        "end_date"         => 5
      }

      post 'create', offer: create_offer_params, rest_id: @restaurant
      result_offer = assigns(:offer)
      expect(result_offer).to be_truthy
      response.should redirect_to(offer_restaurant_path(@restaurant.slug))
    end
    it "create offer with params offer and user is not restaurant owner" do
      @user.update_attribute('restaurant_owner_role', false)
      create_offer_params = {
        "offer_content"    => Faker::Name.name,
        "time_start_offer" => Time.now,
        "start_time"       => 1200,
        "end_time"         => 1600,
        "start_date"       => 1,
        "end_date"         => 5
      }

      post 'create', offer: create_offer_params, rest_id: @restaurant
      result_offer = assigns(:offer)
      expect(result_offer).to eq nil
    end
  end
end
require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")


describe RestaurantsController, "test" do
  context "Remove favourite action" do
    before :each do
      @user1 = create(:user)
      @restaurant = create(:restaurant, {user_id: @user1.id})
    end  

    it "case 1: login, verified, call remove favourite that removed before, success but do not thing" do 
      sign_in @user1
      xhr :post, "add_favourite", :format => "js", id: @restaurant.id
      expect(assigns[:favourite_or_not]).to eq true
      expect(@user1.reload.favourites.count).to eq 1
      expect(@user1.favourites.first.restaurant_id).to eq @restaurant.id
      xhr :post, "remove_favourite", :format => "js", id: @restaurant.id
      expect(assigns[:favourite_or_not]).to eq false
      expect(@user1.reload.favourites.count).to eq 0
      xhr :post, "remove_favourite", :format => "js", id: @restaurant.id
      expect(assigns[:favourite_or_not]).to eq false
      expect(@user1.reload.favourites.count).to eq 0
      expect(assigns[:restaurant]).to eq @restaurant
      expect(assigns[:favourite_or_not]).to eq false
    end
  end
end
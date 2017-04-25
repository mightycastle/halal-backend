require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")


describe RestaurantsController, "test" do
  context "Add favourite action" do
    before :each do
      @user1 = create(:user)
      @restaurant = create(:restaurant, {user_id: @user1.id})
    end

    it "case 1: Not login, go to page sign in" do       
      xhr :post, "add_favourite", :format => "js", id: @restaurant.id
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login, not verified, favourite can not create" do 
      @user1.update_column(:status, 'unverified')
      sign_in @user1
      xhr :post, "add_favourite", :format => "js", id: @restaurant.id
      expect(assigns[:favourite_or_not]).not_to eq true
      expect(@user1.favourites.count).to eq 0
    end

    it "case 3: login, verified, favourite create success" do 
      sign_in @user1
      xhr :post, "add_favourite", :format => "js", id: @restaurant.id
      expect(assigns[:favourite_or_not]).to eq true
      expect(@user1.reload.favourites.count).to eq 1
      expect(@user1.favourites.first.restaurant_id).to eq @restaurant.id
      xhr :post, "remove_favourite", :format => "js", id: @restaurant.id
      expect(assigns[:favourite_or_not]).to eq false
      expect(@user1.reload.favourites.count).to eq 0
      xhr :post, "add_favourite", :format => "js", id: @restaurant.id
      expect(assigns[:favourite_or_not]).to eq true
      expect(@user1.reload.favourites.count).to eq 1
      expect(@user1.favourites.first.restaurant_id).to eq @restaurant.id      
    end
  end
end
require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")


describe RestaurantsController, "test" do
  context "Disable toggle action" do
    before :each do
      @admin = create(:user)
      @admin.update_column(:admin_role, true)
      @user1 = create(:user)
      @restaurant = create(:restaurant, {user_id: @user1.id})
    end

    it "case 1: Not login, go to page sign in" do       
      xhr :post, "disable_toggle", :format => "js", id: @restaurant.slug
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login, owner, go to home page" do 
      sign_in @user1
      xhr :post, "disable_toggle", :format => "js", id: @restaurant.slug
      response.should redirect_to('/')
    end

    it "case 3: login, admin, restaurant is enable, toggle successful to disable" do 
      sign_in @admin
      xhr :post, "disable_toggle", :format => "js", id: @restaurant.slug      
      expect(@restaurant.reload.disabled).to eq true
    end

    it "case 4: login, admin, restaurant is disable, toggle successful to enable" do 
      @restaurant.update_column(:disabled, true)
      sign_in @admin
      xhr :post, "disable_toggle", :format => "js", id: @restaurant.slug
      expect(@restaurant.reload.disabled).to eq false
    end
  end
end
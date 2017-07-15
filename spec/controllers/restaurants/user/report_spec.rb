require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")


describe RestaurantsController, "test" do
  context "Report restaurant" do
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      @restaurant = create(:restaurant, {user_id: @user1.id})      
    end  

    it "case 1: not login , call action, should redirect to sign in" do
      xhr :post, "report", format: "js" , id: @restaurant.slug, is_closed: "1", has_incorrect_information: "1", more_details: "1111111111111111111111111111", restaurant_id: @restaurant.id
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login, call action" do 
      sign_in @user2
      xhr :post, "report", format: "js" , id: @restaurant.slug, is_closed: "1", has_incorrect_information: "1", more_details: "1111111111111111111111111111", restaurant_id: @restaurant.id
      expect(assigns[:no_report_info]).to eq false
    end
  end
end
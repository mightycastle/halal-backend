require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")

describe RestaurantsController, "test" do
  context "Admin edit action" do
    before :each do
      @admin = create(:user)
      @admin.update_column(:admin_role, true)
      @user1 = create(:user)
      @restaurant = create(:restaurant, {user_id: @user1.id})
    end

    it "case 1: not login" do
      get "edit", id: @restaurant.slug
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login, owner" do
      sign_in @user1
      get "edit", id: @restaurant.slug
      response.should redirect_to("/")
    end    

    it "case 3: login, admin" do
      sign_in @admin
      get "edit", id: @restaurant.slug
      response.should render_template('edit')
      expect(assigns[:restaurant]).to eq @restaurant
    end        
  end
end
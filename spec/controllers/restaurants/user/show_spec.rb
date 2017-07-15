require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")


describe RestaurantsController, "test" do
  context "Show action" do
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @review = create_basic_review(@restaurant, @user2)      
    end

    it "case 1: Not login, go to page show" do       
      get "show", id: @restaurant.slug
      response.should render_template('show')
      expect(assigns[:restaurant].id).to eq @restaurant.id
      expect(assigns[:reviews]).to eq [@review]
    end

    it "case 2: login, not owner, go to page show" do 
      sign_in @user2
      get "show", id: @restaurant.slug
      response.should render_template('show')
      expect(assigns[:restaurant]).to eq @restaurant
      expect(assigns[:reviews]).to eq [@review]
    end

    it "case 3: login, owner, go to page manage" do 
      sign_in @user1
      get "show", id: @restaurant.slug
      response.should render_template('user_restaurants')
      expect(assigns[:restaurant]).to eq @restaurant
      expect(assigns[:reviews]).to eq [@review]
    end
  end
end
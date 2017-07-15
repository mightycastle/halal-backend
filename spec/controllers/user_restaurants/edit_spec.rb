require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")

describe UserRestaurantsController, "test123" do

  context "Edit" do
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @schedules = create_basic_schedules(@restaurant)      
    end

    it "Not login, redirect to sign in" do       
      get "edit", id: @restaurant.slug
      response.should redirect_to('/users/sign_in')
    end

    it "login, not owner, redirect to home page" do       
      sign_in @user2
      get "edit", id: @restaurant.slug
      response.should redirect_to('/')
    end

    it "login, owner, render template edit" do  
      sign_in @user1     
      get "edit", id: @restaurant.slug
      response.should render_template('edit')
      expect(assigns[:restaurant]).to eq @restaurant
      expect(assigns[:restaurant].schedules.select{|r| r.new_record? }.count).to eq 7
      expect(@schedules & assigns[:restaurant].schedules == @schedules).to eq true
    end    
  end  
end
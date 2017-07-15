require 'spec_helper'
require "rails_helper"
require Rails.root.join("spec/helpers/restaurant_helper.rb")
describe SearchController, :type => :controller do
  before :each do
    clear_database
    @user = create(:user)
    @restaurant = create(:restaurant)
    @restaurant2 = create(:restaurant)
  end

  
  context "Search controller" do
    it "case 1: render template by_location by search name " do
      @params_search = {
        'ln' => @restaurant.name
      }
      post 'by_location', @params_search
      response.should render_template :by_location
      expect(assigns[:restaurants].length).to eq 1
    end
    it "case 2: render template by_location by search location" do
      @params_search = {
        'user_id' => @user.id,
        'lat' => 10.797576,
        'lon' => 106.6674828
      }
      post 'by_location',  @params_search
      response.should render_template :by_location
      expect(assigns[:restaurants].length).to eq 2
      expect(assigns[:restaurants].map{|rest| rest['name']} & [@restaurant.name, @restaurant2.name]).to eq(assigns[:restaurants].map{|rest| rest['name']})
    end

    it "case 3: render template by_location by search location but no result, so it get all to return" do
      @restaurant3 = create(:restaurant)
      @params_search = {
        'user_id' => @user.id,
        'lat' => 11.797576,
        'lon' => 116.6674828
      }
      post 'by_location',  @params_search
      response.should render_template :by_location
      expect(assigns[:restaurants].length).to eq 3
      expect(assigns[:restaurants].map{|rest| rest['name']} & [@restaurant.name, @restaurant2.name, @restaurant3.name]).to eq(assigns[:restaurants].map{|rest| rest['name']})
    end

    it "case 4: render template by_location by search filter." do
      create_filters([@restaurant, @restaurant2])
      filter =  Filter.last
      filter_type = filter.filter_type
      @params_search = {
        'user_id' => @user.id,
        'filter_ids' => ["#{filter.id},#{filter_type.id}"]
      }
      post 'by_location',@params_search
      response.should render_template :by_location
      expect(assigns[:restaurants].length).to eq 2
      expect(assigns[:restaurants].map{|rest| rest['name']} & [@restaurant.name, @restaurant2.name]).to eq(assigns[:restaurants].map{|rest| rest['name']})
    end

    it "case 5: render template by_location by search filter but no result." do
      create_filters([@restaurant, @restaurant2])
      filter =  Filter.last
      filter_type = filter.filter_type
      @params_search = {
        'user_id' => @user.id,
        'filter_ids' => ["#{filter.id + 100},#{filter_type.id + 20}"]
      }
      post 'by_location',@params_search
      response.should render_template :by_location
      expect(assigns[:restaurants].length).to eq 0
    end

  end
end
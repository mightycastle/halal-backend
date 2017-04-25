# encoding: utf-8
require "rails_helper"
require Rails.root.join("spec/helpers/restaurant_helper.rb")
describe RestaurantsAPI, :type => :request do
  before :each do
    clear_database
    @user = create(:user)
    @restaurant = create(:restaurant)
    @restaurant2 = create(:restaurant)
    @user.ensure_authentication_token!
    @request_headers = {
      'HTTP_ACCEPT' => 'application/json',
      'HTTP_CONTENT_TYPE' => 'application/json',
      'HTTP_APIKEY' => API_KEY_ANDROID,
      'HTTP_USERTOKEN' => @user.reload.authentication_token
    }

  end
  context "Search service" do
    it "case 1: search with name but there no result" do
      @params_search = {
        'key_search' => 'name k ton tai',
        'zoom_level' => nil,
        'page_size' => nil,
        'page_index' => nil,
        'lat' => nil,
        'long' => nil,
        'filter_ids' => nil
      }
      get '/v1.2/restaurants/search.json', @params_search ,@request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["message"]).to eq I18n.t( "service_api.success.none_restaurants" )
    end

    it "case 2: search with name with some restautant matched it." do
      @params_search = {
        'key_search' => @restaurant.name,
        'zoom_level' => nil,
        'page_size' => nil,
        'page_index' => nil,
        'lat' => nil,
        'long' => nil,
        'filter_ids' => nil
      }
      get '/v1.2/restaurants/search.json', @params_search, @request_headers
      output = JSON.parse(URI.decode(response.body))
      
      expect(output["data"].length).not_to eq 0
      expect(output["data"].map{|r| r['id']}).to include(@restaurant.id.to_s)
      expect(output["message"]).to eq I18n.t( "service_api.success.get_list_by_name" )
    end

    it "case 3: search with location but there no result but have results near that location" do
      @params_search = {
        'lat' => 10.797576,
        'long' => 106.6674828
      }
      get '/v1.2/restaurants/search.json', @params_search, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["message"]).to eq I18n.t( "service_api.success.get_list_by_name" )
      expect(output["data"].length).to eq(2)
      expect([@restaurant.id.to_s, @restaurant2.id.to_s] & output["data"].map{|rest| rest['id']} == [@restaurant.id.to_s, @restaurant2.id.to_s]).to eq true
    end

    it "case 4: search with location, but there no results in it or nearly. But system get all to return" do
      @params_search = {
        'lat' => 10.9248743,
        'long' => 106.8083471
      }
      get '/v1.2/restaurants/search.json', @params_search, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["data"].length).to eq(2)
      expect(output["message"]).to eq I18n.t( "service_api.success.get_list_by_name" )
    end

    it "case 5: search with location with some restautant in it." do
      @params_search = {
        'lat' => 10.7717395,
        'long' => 106.669815
      }
      get '/v1.2/restaurants/search.json', @params_search, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["data"].length).to eq(2)
      expect([@restaurant.id.to_s, @restaurant2.id.to_s] & output["data"].map{|rest| rest['id']} == [@restaurant.id.to_s, @restaurant2.id.to_s]).to eq true
      expect(output["message"]).to eq I18n.t( "service_api.success.get_list_by_name" )
    end

    it "case 6: search with filter with some restautant in it." do
      create_filters([@restaurant, @restaurant2])
      filter =  Filter.last
      filter_type = filter.filter_type
      @params_search = {
        'filter_ids' => ["#{filter.id},#{filter_type.id}"].to_s
      }
      get '/v1.2/restaurants/search.json', @params_search, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect([@restaurant.id.to_s, @restaurant2.id.to_s] & output["data"].map{|rest| rest['id']} == [@restaurant.id.to_s, @restaurant2.id.to_s]).to eq true
      expect(output["message"]).to eq I18n.t( "service_api.success.get_list_by_name" )
    end
    
    it "case 7: search with filter with no restautant in it." do
      create_filters([@restaurant, @restaurant2])
      filter =  Filter.last
      filter_type = filter.filter_type
      @params_search = {
        'key_search' => 'name k ton tai',
        'filter_ids' => ["99999,3456"].to_s
      }
      get '/v1.2/restaurants/search.json', @params_search, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["message"]).to eq I18n.t( "service_api.success.none_restaurants" )
    end
  end
end
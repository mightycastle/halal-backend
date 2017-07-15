# encoding: utf-8
require "rails_helper"

describe RestaurantsAPI, :type => :request do

  # ============================================================================
  context "Get favourite list" do
    before :each do
      @user = create(:user)
      @restaurant_1 = create(:restaurant)
      @restaurant_2 = create(:restaurant)
      @restaurant_3 = create(:restaurant)
      @user.ensure_authentication_token!
      @request_headers = {
        'HTTP_ACCEPT' => 'application/json',
        'HTTP_CONTENT_TYPE' => 'application/json',
        'HTTP_APIKEY' => API_KEY_ANDROID,
        'HTTP_USERTOKEN' => @user.reload.authentication_token
      }
    end

    it "success with no favourited restaurants" do
      get "/v1.2/restaurants/favourite_list.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.none_favourites")
      expect(output["data"]).to be_empty
    end

    it "success with favourited restaurants" do
      post "/v1.2/restaurants/#{@restaurant_1.id}/add_to_favourite_list.json", nil, @request_headers
      post "/v1.2/restaurants/#{@restaurant_2.id}/add_to_favourite_list.json", nil, @request_headers
      post "/v1.2/restaurants/#{@restaurant_3.id}/add_to_favourite_list.json", nil, @request_headers
      get "/v1.2/restaurants/favourite_list.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.get_list_favourites")
      expect(output["data"]).not_to be_empty
      expect(output["data"].count).to equal 3
      post "/v1.2/restaurants/#{@restaurant_2.id}/remove_from_favourite_list.json", nil, @request_headers
      get "/v1.2/restaurants/favourite_list.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.get_list_favourites")
      expect(output["data"]).not_to be_empty
      expect(output["data"].count).to equal 2
      output["data"].each do |restaurant|
        expect([@restaurant_1.id, @restaurant_3.id]).to include(restaurant["id"].to_i)
        expect(restaurant["name"]).not_to be_nil
        expect(restaurant["image"]).not_to be_nil
        expect(restaurant["address"]).not_to be_nil
        expect(restaurant["country"]).not_to be_nil
        expect(restaurant["description"]).not_to be_nil
        expect(restaurant["status"]).not_to be_nil
        expect(restaurant["price"]).not_to be_nil
        expect(restaurant["rating"]).not_to be_nil
        expect(restaurant["review_number"]).not_to be_nil
        expect(restaurant["distance"]).not_to be_nil
        expect(restaurant["postcode"]).not_to be_nil
        expect(restaurant["website"]).not_to be_nil
        expect(restaurant["is_favourite"]).not_to be_nil
        expect(restaurant["lat"]).not_to be_nil
        expect(restaurant["long"]).not_to be_nil
        expect(restaurant["halal_status"]).not_to be_nil
        expect(restaurant["opening_hours"]).not_to be_nil
        expect(restaurant["cuisine"]).not_to be_nil
        expect(restaurant["restaurant_url"]).not_to be_nil
      end
    end

  end

end
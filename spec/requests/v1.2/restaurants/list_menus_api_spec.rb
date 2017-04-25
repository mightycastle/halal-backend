# encoding: utf-8
require "rails_helper"

describe RestaurantsAPI, :type => :request do

  # ============================================================================
  context "Get restaurant reviews" do
    before :each do
      @user = create(:user)
      @restaurant_1 = create(:restaurant)
      @user.ensure_authentication_token!
      @request_headers = {
        'HTTP_ACCEPT' => 'application/json',
        'HTTP_CONTENT_TYPE' => 'application/json',
        'HTTP_APIKEY' => API_KEY_ANDROID,
        'HTTP_USERTOKEN' => @user.reload.authentication_token
      }
    end

    it "fail with wrong api key" do
      @request_headers["HTTP_APIKEY"] = Faker::Name.name
      get "/v1.2/restaurants/#{@restaurant_1.id}/menus.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.invalid_api_key")
      expect(output["error"]).to eq 401
    end

    it "fail with wrong user token" do
      @request_headers["HTTP_USERTOKEN"] = Faker::Name.name
      get "/v1.2/restaurants/#{@restaurant_1.id}/menus.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.wrong_authentication_token")
      expect(output["error"]).to eq 600
    end

    it "retaurant not found" do
      get "/v1.2/restaurants/99999/menus.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.restaurant_not_found")
      expect(output["error"]).to eq 1000
    end

    it "retaurant not have menu yet" do
      get "/v1.2/restaurants/#{@restaurant_1.id}/menus.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.none_menus")
      expect(output["data"]).to be_empty
    end

    it "success with valid params" do
      photo = fixture_file_upload("/images/test.jpg", 'image/jpg')
      create(:menu, {restaurant_id: @restaurant_1.id, user_id: @user.id, name: "menu1.jpg", menu: photo})
      photo = fixture_file_upload("/images/test.jpg", 'image/jpg')
      create(:menu, {restaurant_id: @restaurant_1.id, user_id: @user.id, name: "menu1.jpg", menu: photo})
      get "/v1.2/restaurants/#{@restaurant_1.id}/menus.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.get_restaurant_menus")
      expect(output["data"]).not_to be_nil
      expect(output["data"].count).to eq 2
      output["data"].each do |menu|
        expect(menu["name"]).not_to be_nil
        expect(menu["url"]).not_to be_nil
      end
    end

  end

end
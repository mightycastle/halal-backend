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
      get "/v1.2/restaurants/#{@restaurant_1.id}/detail.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.invalid_api_key")
      expect(output["error"]).to eq 401
    end

    it "fail with wrong user token" do
      @request_headers["HTTP_USERTOKEN"] = Faker::Name.name
      get "/v1.2/restaurants/#{@restaurant_1.id}/detail.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.wrong_authentication_token")
      expect(output["error"]).to eq 600
    end

    it "retaurant not found" do
      get "/v1.2/restaurants/99999/detail.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.restaurant_not_found")
      expect(output["error"]).to eq 1000
    end

    it "success with valid params" do
      get "/v1.2/restaurants/#{@restaurant_1.id}/detail.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.get_restaurant_detail")
      expect(output["data"]).not_to be_nil
      expect(output["data"]["id"]).not_to be_nil
      expect(output["data"]["name"]).not_to be_nil
      expect(output["data"]["city"]).not_to be_nil
      expect(output["data"]["email"]).not_to be_nil
      expect(output["data"]["address"]).not_to be_nil
      expect(output["data"]["phone"]).not_to be_nil
      expect(output["data"]["suggester_name"]).not_to be_nil
      expect(output["data"]["suggester_email"]).not_to be_nil
      expect(output["data"]["suggester_phone"]).not_to be_nil
      expect(output["data"]["website"]).not_to be_nil
      expect(output["data"]["is_favourite"]).not_to be_nil
      expect(output["data"]["opening_hours"]).not_to be_nil
      # expect(output["data"]["offer"]).not_to be_nil
      expect(output["data"]["filters"]).not_to be_nil
      # expect(output["data"]["reviews"]).not_to be_nil
      expect(output["data"]["review_count"]).not_to be_nil
      # expect(output["data"]["latest_review"]).not_to be_nil
    end

  end

end
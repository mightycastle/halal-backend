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
      get "/v1.2/restaurants/#{@restaurant_1.id}/reviews/list.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.invalid_api_key")
      expect(output["error"]).to eq 401
    end

    it "fail with wrong user token" do
      @request_headers["HTTP_USERTOKEN"] = Faker::Name.name
      get "/v1.2/restaurants/#{@restaurant_1.id}/reviews/list.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.wrong_authentication_token")
      expect(output["error"]).to eq 600
    end

    it "success with no reviews" do
      get "/v1.2/restaurants/#{@restaurant_1.id}/reviews/list.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.none_reviews")
      expect(output["data"]).to be_empty
    end

    it "success with list reviews" do
      request_params = {
        restaurant_id: @restaurant_1.id,
        service: 1,
        quality: 1,
        value: 1,
        content: 1,
        month: Time.now.month,
        year: Time.now.year,
      }
      review_ids = []
      post "/v1.2/restaurants/#{@restaurant_1.id}/reviews/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      review = Review.last
      review.update_attributes(status: true)
      review_ids.push(review)
      post "/v1.2/restaurants/#{@restaurant_1.id}/reviews/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      review = Review.last
      review.update_attributes(status: true)
      review_ids.push(review)
      post "/v1.2/restaurants/#{@restaurant_1.id}/reviews/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      review = Review.last
      review.update_attributes(status: true)
      review_ids.push(review)
      post "/v1.2/restaurants/#{@restaurant_1.id}/reviews/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      review = Review.last
      review.update_attributes(status: true)
      review_ids.push(review)
      get "/v1.2/restaurants/#{@restaurant_1.id}/reviews/list.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.get_list_reviews")
      expect(output["data"]).not_to be_empty
      output["data"].each do |review|
        expect(review["id"]).not_to be_nil
        expect(review_ids).not_to include(review["id"].to_i)
        expect(review["content"]).not_to be_nil
        expect(review["service"]).not_to be_nil
        expect(review["quality"]).not_to be_nil
        expect(review["value"]).not_to be_nil
        expect(review["status"]).not_to be_nil
        expect(review["rating"]).not_to be_nil
        expect(review["user"]).not_to be_nil
      end
    end

  end

end
# encoding: utf-8
require "rails_helper"

describe FiltersAPI, :type => :request do

  # ============================================================================
  context "Add new restaurant" do
    before :each do
      @user = create(:user)
      @user.ensure_authentication_token!
      @request_headers = {
        'HTTP_ACCEPT' => 'application/json',
        'HTTP_CONTENT_TYPE' => 'application/json',
        'HTTP_APIKEY' => API_KEY_ANDROID,
        'HTTP_USERTOKEN' => @user.reload.authentication_token
      }
    end

    it "fail if wrong user authentication token" do
      @request_headers['HTTP_USERTOKEN'] = Faker::Number.number(16)
      get "/v1.2/filters/cuisine_list.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.wrong_authentication_token")
      expect(output["error"]).to eq 600
    end

    it "get list was successful" do
      get "/v1.2/filters/cuisine_list.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.get_cuisine_list")
      expect(output["data"]).not_to be nil
      output["data"].each do |filter|
        expect(filter["id"]).to be_truthy
        expect(filter["code"]).to eq "cuisine"
        expect(filter["name"]).to be_truthy
        expect(filter["description"]).to be_truthy
      end

    end

  end

end



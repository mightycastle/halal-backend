# encoding: utf-8
require "rails_helper"

describe StaticPagesAPI, :type => :request do

  # ============================================================================
  context "Add new restaurant" do
    before :each do
      @request_headers = {
        'HTTP_ACCEPT' => 'application/json',
        'HTTP_CONTENT_TYPE' => 'application/json',
        'HTTP_APIKEY' => API_KEY_ANDROID
      }
    end

    it "fail with wrong api key" do
      @request_headers["HTTP_APIKEY"] = Faker::Name.name
      get "/v1.2/static_pages/1/show.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.invalid_api_key")
      expect(output["error"]).to eq 401
    end

    it "page not found with invalid page id" do
      get "/v1.2/static_pages/9999/show.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("service_api.errors.page_not_found")
      expect(output["error"]).to eq 604
    end

    it "get page was successful" do
      get "/v1.2/static_pages/1/show.json", nil, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.get_static_page")
      expect(output["data"]).not_to be_empty
      output["data"].each do |page|
        expect(page).not_to be_empty
      end

    end

  end

end



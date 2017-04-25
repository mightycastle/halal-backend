# encoding: utf-8
require "rails_helper"
require Rails.root.join("spec/helpers/user_helper.rb")
describe RestaurantsAPI, :type => :request do

  # ============================================================================
  context "Add new restaurant" do
    before :each do
      clear_database
      @user = create(:user)
      @user.ensure_authentication_token!
      @request_headers = {
        'HTTP_ACCEPT' => 'application/json',
        'HTTP_CONTENT_TYPE' => 'application/json',
        'HTTP_APIKEY' => API_KEY_ANDROID,
        'HTTP_USERTOKEN' => @user.reload.authentication_token
      }
    end

    it "fail if field name was missing" do
      request_params = {
        # name: Faker::Name.name,
        city: Faker::Address.city,
        email: Faker::Internet.email,
        address: Faker::Address.street_address,
        phone: Faker::Number.number(10)
      }
   
      post "/v1.2/restaurants/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["error"]).to eq 403
    end

    it "fail if field city was missing" do
      request_params = {
        name: Faker::Name.name,
        # city: Faker::Address.city,
        email: Faker::Internet.email,
        address: Faker::Address.street_address,
        phone: Faker::Number.number(10)
      }
      post "/v1.2/restaurants/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["error"]).to eq 403
    end

    it "fail if field email was missing" do
      request_params = {
        name: Faker::Name.name,
        city: Faker::Address.city,
        # email: Faker::Internet.email,
        address: Faker::Address.street_address,
        phone: Faker::Number.number(10)
      }
      post "/v1.2/restaurants/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["error"]).to eq 403
    end

    it "fail if field address was missing" do
      request_params = {
        name: Faker::Name.name,
        city: Faker::Address.city,
        email: Faker::Internet.email,
        # address: Faker::Address.street_address,
        phone: Faker::Number.number(10)
      }
      post "/v1.2/restaurants/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["error"]).to eq 403
    end

    it "fail if field phone was missing" do
      request_params = {
        name: Faker::Name.name,
        city: Faker::Address.city,
        email: Faker::Internet.email,
        address: Faker::Address.street_address,
        # phone: Faker::Number.number(10)
      }
      post "/v1.2/restaurants/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["error"]).to eq 403
    end

    it "fail if wrong format email" do
      request_params = {
        name: Faker::Name.name,
        city: Faker::Address.city,
        email: Faker::Name.name,
        address: Faker::Address.street_address,
        phone: Faker::Number.number(10),

        service: 1, quality: 2, value: 3,
        content: 4, month: 5, year: 2014
      }
      post "/v1.2/restaurants/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("errors.invalid_email")
      expect(output["error"]).to eq 403
    end

    it "fail if fields service, quality, value, content, month, year are not present together" do
      request_params = {
        name: Faker::Name.name,
        city: Faker::Address.city,
        email: Faker::Internet.email,
        address: Faker::Address.street_address,
        phone: Faker::Number.number(10),

        service: 1, quality: 2, value: 3,
        content: 4, month: 5, year: 2014
      }
      ["service", "quality", "value", "content", "month", "year"].each do |field|
        case field
        when "service"
          request_params[:service] = nil
        when "quality"
          request_params[:quality] = nil
        when "value"
          request_params[:value] = nil
        when "content"
          request_params[:content] = nil
        when "month"
          request_params[:month] = nil
        when "year"
          request_params[:year] = nil
        end
        post "/v1.2/restaurants/create.json", request_params, @request_headers
        output = JSON.parse(response.body)
        expect(output["success"]).to eq false
        expect(output["message"]).to eq I18n.t("service_api.errors.missing_required_fields")
        expect(output["error"]).to eq 333
      end
    end
    
    it "fail if fields suggester_name, suggester_email, suggester_phone are not present together" do
      request_params = {
        name: Faker::Name.name,
        city: Faker::Address.city,
        email: Faker::Internet.email,
        address: Faker::Address.street_address,
        phone: Faker::Number.number(10),

        suggester_name: Faker::Name.name,
        suggester_email: Faker::Internet.email,
        suggester_phone: Faker::Number.number(10),
      }
      ["suggester_name", "suggester_email", "suggester_phone"].each do |field|
        case field
        when "suggester_name"
          request_params[:suggester_name] = nil
        when "suggester_email"
          request_params[:suggester_email] = nil
        when "suggester_phone"
          request_params[:suggester_phone] = nil
        end
        post "/v1.2/restaurants/create.json", request_params, @request_headers
        output = JSON.parse(response.body)
        expect(output["success"]).to eq false
        expect(output["message"]).to eq I18n.t("service_api.errors.missing_required_fields")
        expect(output["error"]).to eq 333
      end
    end

    it "fail if wrong format suggester_email" do
      request_params = {
        name: Faker::Name.name,
        city: Faker::Address.city,
        email: Faker::Internet.email,
        address: Faker::Address.street_address,
        phone: Faker::Number.number(10),

        suggester_name: Faker::Name.name,
        suggester_email: Faker::Name.name,
        suggester_phone: Faker::Number.number(10),
      }
      post "/v1.2/restaurants/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output["message"]).to eq I18n.t("errors.invalid_suggester_email")
      expect(output["error"]).to eq 403
    end

    it "created new retaurant with valid params" do
      request_params = {
        name: Faker::Name.name,
        city: Faker::Address.city,
        email: Faker::Internet.email,
        address: Faker::Address.street_address,
        phone: Faker::Number.number(10),
        
        service: 1, quality: 2, value: 3,
        content: 4, month: 5, year: 2014
      }
      post "/v1.2/restaurants/create.json", request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq true
      expect(output["message"]).to eq I18n.t("service_api.success.add_restaurant")
      expect(output["data"]["id"]).not_to be_nil
    end

  end

end
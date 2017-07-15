# encoding: utf-8
require "rails_helper"

describe UsersAPI, :type => :request do
  before :each do
    @user = create(:user)
    @request_headers = {
      'HTTP_ACCEPT' => 'application/json',
      'HTTP_CONTENT_TYPE' => 'application/json',
      'HTTP_APIKEY' => API_KEY_ANDROID,
      'HTTP_USERTOKEN' => ""
    }
  end
  # ============================================================================
  context "Login" do
    # before :each do
    #   @user = create(:user)
    #   @request_headers = {
    #     'HTTP_ACCEPT' => 'application/json',
    #     'HTTP_CONTENT_TYPE' => 'application/json',
    #     'HTTP_APIKEY' => API_KEY_ANDROID,
    #     'HTTP_USERTOKEN' => ""
    #   }
    # end

    it "fail if fields are missing" do
      request_params = {
        email: nil,
        password: nil,
        fb_access_token: nil,
        device_token: Faker::Number.number(10),
        device_type: 1
      }
      post "/v1.2/users/login.json", request_params, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["success"]).to eq false
      expect(output["error"]).to eq 403
      expect(output['message']).to eq I18n.t("service_api.login.missing_login_params")
    end


    it "fail if field device_token/device_type is missing" do
      request_params = {
        email: nil,
        password: nil,
        fb_access_token: nil,
        device_token: Faker::Number.number(10),
        device_type: nil
      }
      post "/v1.2/users/login.json", request_params, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["success"]).to eq false
      expect(output["error"]).to eq 603
      expect(output['message']).to eq I18n.t("service_api.login.invalid_device_type")
    end

    it "fail if field password is wrong" do
      request_params = {
        email: @user.email,
        password: 'password',
        fb_access_token: nil,
        device_token: Faker::Number.number(10),
        device_type: 1
      }
      post "/v1.2/users/login.json", request_params, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["success"]).to eq false
      expect(output["error"]).to eq 401
      expect(output['message']).to eq I18n.t("service_api.errors.wrong_email_password")
    end

    it "fail if field email is un-exist" do
      request_params = {
        email: 'email_abc@gmail.com',
        password: 'password',
        fb_access_token: nil,
        device_token: Faker::Number.number(10),
        device_type: 1
      }
      post "/v1.2/users/login.json", request_params, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["success"]).to eq false
      expect(output["error"]).to eq 602
      expect(output['message']).to eq I18n.t("service_api.errors.wrong_login_detail")
    end

    it "fail if account is locked" do
      @user.update_attribute('status', User::STATUS[0])
      request_params = {
        email: @user.email,
        password: 12345678,
        fb_access_token: nil,
        device_token: Faker::Number.number(10),
        device_type: 1
      }
      post "/v1.2/users/login.json", request_params, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["success"]).to eq false
      expect(output["error"]).to eq 404
      expect(output['message']).to eq I18n.t("service_api.errors.locked")
    end    

    it "success if email/password are correct" do
      @user.update_attribute('status', User::STATUS[1])
      request_params = {
        email: @user.email,
        password: 12345678,
        fb_access_token: nil,
        device_token: Faker::Number.number(10),
        device_type: 1
      }
      post "/v1.2/users/login.json", request_params, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output["success"]).to eq true
      expect(output['message']).to eq I18n.t("service_api.login.successful")
      expect(output['data']['id']).to eq @user.id
      expect(output['data']['email']).to eq @user.email
      expect(output['data']['username']).to eq @user.username
    end    
  end

  context "Sign up" do
    it "case 1: sign up successful with valid params" do
      request_params = {
        email: 'abccdd@gmail.com',
        password: 12345678,
        username: 'username'
      }
      post "/v1.2/users/register.json",  request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output['message']).to eq I18n.t("service_api.sign_up.successful")
    end

    it "case 2: get 422 when miss some params" do
      request_params = {
        email: nil,
        password: 12345678,
        username: 'username'
      }
      post "/v1.2/users/register.json",  request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output['error']).to eq 403
      expect(output['message']).to eq I18n.t('service_api.errors.missing_required_fields')
    end

    it "case 3: get 422 when sign up with exist email" do
      request_params = {
        email: @user.email,
        password: 12345678,
        username: 'username'
      }
      post "/v1.2/users/register.json",  request_params, @request_headers
      output = JSON.parse(response.body)
      expect(output["success"]).to eq false
      expect(output['error']).to eq 403
    end
  end

  context "Sign out" do
    before :each do
      @request_headers['HTTP_USERTOKEN'] = @user.reload.authentication_token
    end
    request_params = {
      token: 9999
    }
    it 'case 1: Input invalid id' do
      post "/v1.2/users/destroy.json",  request_params, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output['error']).to eq 403
      expect(output['message']).to eq I18n.t("service_api.errors.wrong_token")
    end


    it 'case 2: Input valid id' do 
      request_params = {
        token: @user.reload.authentication_token
      }
      post "/v1.2/users/destroy.json",  request_params, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output['message']).to eq I18n.t('service_api.success.log_out')

    end
  end

  context "Get personal information" do
    before :each do
      @user.ensure_authentication_token!
      @request_headers['HTTP_USERTOKEN'] = @user.reload.authentication_token
    end
    it 'case 1: Input invalid user id' do
      request_params = {
        user_id: 99999
      }
      get "/v1.2/users/#{request_params[:user_id]}/user_info.jso", nil, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output['error']).to eq 604
      expect(output['message']).to eq  I18n.t("service_api.errors.user_not_found")
    end

    it 'case 2: Input valid user id' do 
      request_params = {
        user_id: @user.id
      }
      get "/v1.2/users/#{request_params[:user_id]}/user_info.jso", nil, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output['data']['id']).to eq @user.id
      expect(output['data']['email']).to eq @user.email
      expect(output['data']['username']).to eq @user.username
      expect(output['data']['first_name']).to eq @user.first_name
      expect(output['data']['last_name']).to eq @user.last_name
      expect(output['data']['phone']).to eq @user.phone
      expect(output['message']).to eq  I18n.t("service_api.success.get_user_profile")
    end
  end

  context 'Test for reset password' do
    it 'case 1: Input invalid email' do
      request_params = {
        email: 'example_invalid@gmail.com'
      }
      post "/v1.2/users/forgot_password.json", request_params, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output['error']).to eq 442
      expect(output['message']).to eq I18n.t("service_api.errors.user_not_found")
    end


    it 'case 2: Input valid email' do 
      request_params = {
        email: @user.email
      }
      post "/v1.2/users/forgot_password.json", request_params, @request_headers
      output = JSON.parse(URI.decode(response.body))
      expect(output['message']).to eq  I18n.t("service_api.reset_password.send_email")
    end
  end
end

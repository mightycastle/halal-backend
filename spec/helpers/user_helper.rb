def set_request_header(header)  
  request.env['Accept'] = header['HTTP_ACCEPT'] || 'application/json'
  request.env['Content-Type'] = header['HTTP_CONTENT_TYPE'] || 'application/json'
  request.env['Usertoken'] = header['HTTP_USERTOKEN'] || nil
  request.env['Apikey'] = header['HTTP_APIKEY'] || API_KEY_ANDROID
end

def expect_wrong_authenticate(output)
  output['status'].should eq 401
  expect(output['message']).to eq I18n.t("service_api.login.wrong_authentication_token")
end

def parse_json_body(response)
  JSON.parse(URI.decode(response.body))
end

def subscribe_user(user)
  user.update_column(:is_subscribed, true)
  create(:subscription, {user_id: user.id})
end

def clear_database
	User.destroy_all
	Restaurant.destroy_all
end
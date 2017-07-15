require 'grape'
require 'grape-swagger'

class API < Grape::API
  # use Rack::Session::Cookie
  # When there's an error, this is what to due, send it back as JSON
  # rescue_from :all, :backtrace => false
  
  rescue_from :all, backtrace: false do |e|
    message = (Rails.env == 'production' ? I18n.t('api.default_error') : e.message)
    Rack::Response.new({success: false, message: message, error: 403}.to_json, 201)
  end

  # if Rails.env.production? || Rails.env.staging?
  #   extend NewRelic::Agent::Instrumentation::Rack
  # end

  default_error_formatter :json
  format :json
  default_format :json
  version 'v1.2', using: :path, vendor: 'Halalgems'
  # Import any helpers that you need
  helpers APIHelpers
  

  before do
    api_authenticate
    force_utf8_params
  end

  # Mount all API module
  mount UsersAPI
  mount RestaurantsAPI
  mount StaticPagesAPI
  mount FiltersAPI
  # add_swagger_documentation

  
  add_swagger_documentation markdown: true, api_version: 'v1.2', hide_documentation_path: true
end
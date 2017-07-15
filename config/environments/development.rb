Halalgems::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  CURRENT_HOST = "localhost:3000"
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options = { :host => CURRENT_HOST }
  
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    paypal_options = {
      :login => 'app_halalgems_test_api1.gmail.com',
      :password => '7LQZKM7BMFZP7Q6G',
      :signature => 'AFcWxV21C7fd0v3bYYYRCpSSRl31AW1DbZhFlnCeCykvx4-zEYja9GYs'
    }
    ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end

Devise.mailchimp_api_key = '149fcc9f37c0ba9a5effdf0f97e958eb-us4'
Devise.mailing_list_name = 'Halalgems_staging'
MAILING_LIST_OWNER = 'halalgems_restaurant_owner'
GET_OFFER_LIST_EMAIL = 'Get_offer_halalgems'

EMAIL_CONTACT_US         = "tinnv@nexlesoft.com"
FACEBOOK_APP_ID          = "655021631220629"
FACEBOOK_APP_SECRET      = "96fb376cb92ac96e1ff8b92da40ee418"

ENV['SECRET_APP_TOKEN']="6cfc2c1e34f037e9b1d32ae6bc564db80affdbd839c794690b7c7640d56fc911c91b7af4ff00595e47b58d4f3c9a8308a0ece1e8dfc63fc85cbf69da90470de9"
ENV['HALALGEMS_PEPPER']="ecff046d8747d4a596f8b9efa6bc01a36cb5f436d81ed2010787351caf0bf3aa37017061d541b19cab0cce801d4b2a782a1ee52a7e0d2f7a8433a9179c5a7711"

ENV['PAYPAL_USERNAME']="app_halalgems_test_api1.gmail.com"
ENV['PAYPAL_PASSWORD']="7LQZKM7BMFZP7Q6G"
ENV['PAYPAL_SIGNATURE']="AFcWxV21C7fd0v3bYYYRCpSSRl31AW1DbZhFlnCeCykvx4-zEYja9GYs"

ENV['SMTP_EMAIL_PASSWORD']="52cc0388-b1cb-4820-b3da-7801ecf1732b"


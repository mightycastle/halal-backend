PayPal::Recurring.configure do |config|
  if Rails.env == 'development' || Rails.env == 'staging' || Rails.env == 'test'
    config.sandbox = true
    config.username = ENV["PAYPAL_USERNAME"]
    config.password = ENV["PAYPAL_PASSWORD"]
    config.signature = ENV["PAYPAL_SIGNATURE"]
  elsif Rails.env == 'production'
    config.sandbox = false
    config.username = ENV["PAYPAL_USERNAME"]
    config.password = ENV["PAYPAL_PASSWORD"]
    config.signature = ENV["PAYPAL_SIGNATURE"]
  end
end

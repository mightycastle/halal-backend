Halalgems::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  CURRENT_HOST = "halalgems.com/restaurants"
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false 
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true
  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
   config.force_ssl = false

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( admin.js admin.css )
  config.assets.precompile += %w( manager.js manager.css )
  config.assets.precompile += Ckeditor.assets
  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => CURRENT_HOST }
  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :production
    paypal_options = {
      :login => 'zohra_api1.halalgems.com',
      :password => 'DYFU7D4S9GSLRTWN',
      :signature => 'AK1C-Qn-hhX8yxt-mPwvLNnNCeT1AEqSYssK085lY-r50C90l5AK4K40'
    }
    ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end

#zkhaku/HGUser1230
Devise.mailchimp_api_key = '149fcc9f37c0ba9a5effdf0f97e958eb-us4'
Devise.mailing_list_name = 'HalalGems.com'
MAILING_LIST_OWNER = 'halalgems_restaurant_owner'
GET_OFFER_LIST_EMAIL = 'HalalGems.com'

EMAIL_CONTACT_US = "info@halalgems.com"
FACEBOOK_APP_ID = "655021631220629"
FACEBOOK_APP_SECRET = "96fb376cb92ac96e1ff8b92da40ee418"

ENV['SECRET_APP_TOKEN']="6cfc2c1e34f037e9b1d32ae6bc564db80affdbd839c794690b7c7640d56fc911c91b7af4ff00595e47b58d4f3c9a8308a0ece1e8dfc63fc85cbf69da90470de9"
ENV['HALALGEMS_PEPPER']="ecff046d8747d4a596f8b9efa6bc01a36cb5f436d81ed2010787351caf0bf3aa37017061d541b19cab0cce801d4b2a782a1ee52a7e0d2f7a8433a9179c5a7711"

ENV['PAYPAL_USERNAME']="zohra_api1.halalgems.com"
ENV['PAYPAL_PASSWORD']="DYFU7D4S9GSLRTWN"
ENV['PAYPAL_SIGNATURE']="AK1C-Qn-hhX8yxt-mPwvLNnNCeT1AEqSYssK085lY-r50C90l5AK4K40"

ENV['SMTP_EMAIL_PASSWORD']="52cc0388-b1cb-4820-b3da-7801ecf1732b"

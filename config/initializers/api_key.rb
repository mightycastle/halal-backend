# Try to get from environment variables.
api_key_android = ENV["HALALGEMS_API_KEY_ANDROID"]
api_key_ios = ENV["HALALGEMS_API_KEY_IOS"]
api_secret = ENV["HALALGEMS_API_SECRET"]

# Try to read from config file.
config_file = File.join(Rails.root, "config", "api_key.yml")
if ((api_key_ios.blank? && api_key_android.blank?) || api_secret.blank?) && File.exists?(config_file)
  keys = YAML.load(ERB.new(File.read(config_file)).result)[Rails.env]
  if keys
    api_key_android = keys['api_key_android']
    api_key_ios = keys['api_key_ios']
    api_secret = keys['api_secret']
    
  end
end
API_KEY_ANDROID = api_key_android
API_KEY_IOS = api_key_ios
HALALGEMS_API_KEY = [api_key_android, api_key_ios]
HALALGEMS_API_SECRET = api_secret
HALALGEMS_API_EXPIRE = 600 # 600 seconds or 10 minutes

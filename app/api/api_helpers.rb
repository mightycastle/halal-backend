module APIHelpers
  def warden
    env['warden']
  end

  def api_authenticate
    error!(response_error(I18n.t('service_api.errors.invalid_api_key'), 401), 200) unless HALALGEMS_API_KEY.include?(headers["Apikey"])
  end

  def session
    env['rack.session']
  end
  
  def current_user
    User.where(authentication_token: headers['Usertoken']).first
  end
  
  def authenticated
    if headers['Usertoken'] && (@user = User.find_by_authentication_token(headers['Usertoken']))
      return true
    else
      error!(response_error(I18n.t('service_api.errors.wrong_authentication_token'), 600), 200)
    end
  end
  
  def set_user_time_zone
    force_utf8_params
    Time.zone = headers['Timezone'] unless headers['Timezone'].blank?
  end

  def force_utf8_params
    traverse = lambda do |object, block|
      if object.kind_of?(Hash)
        object.each_value { |o| traverse.call(o, block) }
      elsif object.kind_of?(Array)
        object.each { |o| traverse.call(o, block) }
      else
        block.call(object)
      end
      object
    end
    force_encoding = lambda do |o|
      o.force_encoding(Encoding::UTF_8) if o.respond_to?(:force_encoding)
    end
    traverse.call(params, force_encoding)
  end

  def set_locale
    language = headers['Language'] || :en
    I18n.locale = language
  end

  def update_user_locale
    language = headers['Language']
    current_user.update(mobile_lang: language) if current_user.present?
  end

  def user_signed_in?
    warden.authenticated?
  end
  
  def authenticate_user
    authenticated
  end
    
  def access_denied!
    error! "Access Denied", 401
  end

  def bad_request!
    error! "Bad Request", 400
  end
  
  def forbidden_request!
    error! "Forbidden", 403
  end
  
  def not_found!
    error! "Not Found", 404
  end

  def invalid_request!(message)
    error! message, 422
  end

  def response_success_object(message = '', object = {})
    {success: true, message: message, data: object}
  end
  
  def response_success(message = '', data = {})
    {success: true, message: message, data: data}
  end

  def response_success_array(message = '', array = [])
    {success: true, message: message, data: array || []}
  end

  def response_error(message = '', error = 000)
    {success: false, message: message, error: error}
  end

end

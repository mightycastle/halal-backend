require 'grape'

class UsersAPI < Grape::API
  resource :users do
    # Login API
    desc "User login"
    params do 
      optional :email         ,type: String, desc: "Email"
      optional :password         ,type: String, desc: "User's password"
      optional :fb_access_token  ,type: String, desc: "Fb Access Token"
      requires :device_token     ,type: String, desc: 'Device token'
      requires :device_type      ,type: Integer, desc: 'Device type: 0 is Android, 1 is iOS'
    end
    post :login do 
      if params[:device_type].blank? || !User::DEVICE_TYPE.has_value?(params[:device_type])
        return response_error I18n.t("service_api.login.invalid_device_type"), 603
      end
      if (params[:email].blank? || params[:password].blank?) && params[:fb_access_token].blank?
        return response_error I18n.t("service_api.login.missing_login_params"), 403
      end
      if params[:email]
        @user = User.find_by_email(params[:email])
        if @user 
          if !@user.valid_password?(params[:password])
            return response_error I18n.t("service_api.errors.wrong_email_password"),401
          elsif !@user.is_verified?
            return response_error I18n.t("service_api.errors.locked"), 404 
          else
            @user.ensure_authentication_token!
            p "pass"
            @user.update_device_info(params[:device_token], params[:device_type])
            return response_success I18n.t("service_api.login.successful"), User::Entity.represent(@user)
          end
        else
          return response_error I18n.t("service_api.errors.wrong_login_detail"), 602
        end
      end
      # @user = User.first_user_by_fb_user_id(params[:fb_access_token])
      if params[:fb_access_token]
        @user = User.check_fb_login_for_api(params[:fb_access_token])
        if @user.present?
          return response_error I18n.t("service_api.errors.locked"), 404 unless @user.is_verified?
          @user.ensure_authentication_token!
          @user.update_device_info(params[:device_token], params[:device_type])
          return response_success I18n.t("service_api.successful"), User::Entity.represent(@user)
        else
          return response_error I18n.t("service_api.errors.wrong_login_detail"), 602
        end
      end
    end
   
    
    # Get User Profile API
    desc "Get User Profile"
    params do
      requires :id, type: String, desc: "User's id"
    end
    route_param :id do
      get :user_info do
        authenticate_user
        user = User.find_by_id(params[:id])
        if user
          response_success I18n.t("service_api.success.get_user_profile"), User::Entity.represent(user, type: :detail )
        else
          response_error I18n.t("service_api.errors.user_not_found"), 604
        end
      end
    end

    # Sign up API
    desc "Register account"
    params do 
      requires :username, type: String, desc: "User's name"
      requires :email, type: String, desc: "User's email"
      requires :password, type: String, desc: "User's password"
    end

    post :register do
      if (params[:email].blank? || params[:password].blank? || params[:username].blank?)
        return response_error I18n.t("service_api.errors.missing_required_fields"), 403
      end
      user = User.new(
        username: params[:username],
        email: URI.decode(params[:email]),
        password: params[:password],
        password_confirmation: params[:password],
      )
      if user.valid?
        user.save
        user.ensure_authentication_token!
        return response_success I18n.t("service_api.sign_up.successful"), User::Entity.represent(user)
      else
        return response_error user.errors.values.join(", "), 403 
      end
    end

   
    # Sign out API
    desc "Sign out"
    params do 
      requires :token, type: String, desc: "token"
    end

    post :destroy do
      @user=User.find_by_authentication_token(params[:token])
      if @user.nil?
        return response_error I18n.t("service_api.errors.wrong_token"), 403
      else
        @user.reset_authentication_token!
        return response_success I18n.t('service_api.success.log_out'), 200
      end
    end

    # Forgot password API
    desc 'Forgot password'
    params do 
      requires :email, type: String, desc: "User's email"
    end
    post :forgot_password do
      user = User.find_by_email(params[:email].downcase)
      if user.present?
        user.send_reset_password_instructions
        response_success I18n.t("service_api.reset_password.send_email")
      else
        response_error I18n.t("service_api.errors.user_not_found"), 442
      end
    end
  end
end


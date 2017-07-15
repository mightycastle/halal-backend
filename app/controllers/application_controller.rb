class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  include ApplicationHelper
  protect_from_forgery
  before_filter :action_set_url_options


  before_filter :store_location
  #check_authorization
  
  rescue_from CanCan::AccessDenied do |exception|  
    flash[:error] = "Access denied!"  
    redirect_to root_url  
  end 

  def action_set_url_options
    if ENV['RAILS_RELATIVE_URL_ROOT']
      @host = request.host+":"+request.port.to_s+"/"+ENV['RAILS_RELATIVE_URL_ROOT']
    else
      @host = request.host+":"+request.port.to_s
    end
    Rails.application.routes.default_url_options = { :host => @host}
  end

  def store_location
    session[:previous_urls] ||= []
    # store unique urls only
#    if request.referer
      exclude = %w(users registered)
      session[:previous_urls] = request.fullpath unless exclude.any? {|a| request.fullpath.include? a}
#    end
  end
  
  def after_sign_in_path_for(resource)
    if current_user && current_user.is_no_active_subscription?
      become_a_member_path
    elsif session[:previous_urls].blank?
      root_path
    else
      session[:previous_urls]
    end
  end

  def staging_path
    if Rails.env.staging?
      "http://halalgems.com/staging"
    else
      root_path
    end

  end
  
#  def after_confirmation_path_for(resouce_name ,resource)
#    session[:previous_urls] || root_path
#  end
  private
  def required_user_login
    if !current_user
      flash[:notice] = I18n.t('user.required_login')
      redirect_to new_user_session_path
    end
  end
  # def user_verified
  #   unless current_user.is_verified?
  #     flash[:notice] = I18n.t('user.required_verify')
  #     redirect_to :back
  #   end
  # end
  def required_admin_role
    unless current_user.is_admin_role?
      flash[:notice] = I18n.t('user.required_admin_role')
      redirect_to root_path
    end
  end

  def required_restaurant_owner_role
    unless current_user.is_restaurant_owner_role?
      flash[:notice] = I18n.t('user.required_restaurant_owner_role')
      redirect_to root_path
    end
  end

  def require_profession_user
    unless current_user.is_profession_user_avail?
      flash[:notice] = I18n.t('user.require_profession_user')      
      redirect_to :back , format: 'html'
    end
  end


  def api_authenticated
    if request.headers['Usertoken'].blank?     
      render :json => { :message => I18n.t("service_api.login.wrong_authentication_token"), :status => 401 }
      return      
    else
      @user = User.where("authentication_token = ?", request.headers['Usertoken']).first
      if @user.blank?
        render :json => { :message => I18n.t("service_api.login.wrong_authentication_token"), :status => 401 }
        return
      end
    end        
  end

  def api_authenticate_user
    api_authenticated
  end

  def api_detect_current_user(current_user, user_id)
    if current_user.blank? || user_id.blank? || current_user.id != user_id.to_i      
      render :json => { :message => I18n.t("service_api.login.wrong_authentication_token"), :status => 401 } 
      false
    else
      true
    end
  end
end

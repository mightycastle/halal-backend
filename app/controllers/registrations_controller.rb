class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!, :only => :update_password
  def new
    super
  end
  #=================================================================================
  #  * Method name: create
  #  * Input: user params
  #  * Output: create new user
  #  * Date modified: August 24, 2012
  #  * Description: customize create function from devise gem
  #=================================================================================
  def create
    if !params[:user][:uid].blank? && !params[:user][:provider].blank?
      params[:user][:status] = "verified"
    else
      params[:user][:status] = "unverified"
    end
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        #respond_with resource, :location => after_sign_up_path_for(resource)
        redirect_to registered_path
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      #workaround: add message notice
      error_msg = ""
      resource.errors.full_messages.each do |msg|
        error_msg << msg << ". "
      end
#      flash[:notice]= error_msg if !error_msg.blank?
      clean_up_passwords resource
      respond_with resource
    end
  end

  def update
    super
  end
  #=================================================================================
  #  * Method name: change_password
  #  * Input: current_user
  #  * Output: 
  #  * Date modified: September 02, 2012
  #  * Description: 
  #=================================================================================
  def change_password
    if !current_user
      redirect_to root_path
    end
    @user = current_user
  end
  #=================================================================================
  #  * Method name: update_password
  #  * Input: user params
  #  * Output: update password for current user
  #  * Date modified: September 02, 2012
  #  * Description: 
  #=================================================================================
  def update_password
    @user = User.find(current_user.id)
    if @user.valid_password?(params[:user][:current_password]) && @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      flash[:notice] = I18n.t('change_password.success')
      redirect_to root_path
    else
      flash[:notice] = I18n.t('change_password.invalid')
      render "change_password"      
    end
  end
end 

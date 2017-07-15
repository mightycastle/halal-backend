class UsersController < ApplicationController
  before_filter :authenticate_user! , :except => [:share_restaurant_via_email]
  before_filter :required_user_login, :only => [:update_avatar, :change_status, :update_email_get_news_offers]
  before_filter :required_admin_role, :only=>[:index, :change_status]
  load_and_authorize_resource
  layout "admin"
  #=================================================================================
  #  * Method name: index
  #  * Input: param q (Ransack gem)
  #  * Output: list users
  #  * Date modified: August 19, 2012
  #  * Description: get list users for admin management
  #=================================================================================
  def index
    @search = User.search(params[:q])
    @users = @search.result.page(params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end


  def check_user
    if params[:user_name].present?      
      @user = User.find_by_username(params[:user_name]) 
      if @user
        render :json => [flag: true, user: @user.as_json(only: [:id])]
      else
        render :json => [flag: false]
      end
    else
      render :json => [flag: true, user: User.new.as_json(only: :id)]
    end
  end


  #=================================================================================
  #  * Method name: send_email_to_restaurant_owner
  #  * params input:  message, restaurant_id
  #  * Output: send email share to friend
  #  * Date modified: December 19, 2013
  #  * Description: send email to owner
  #=================================================================================
  def send_email_restaurant_owner
    if params[:user].present? && params[:user][:restaurant_email].present?
      message = params[:user][:message]
      restaurant_email = params[:user][:restaurant_email]
      @email = UserMailer.send_email_restaurant(restaurant_email, message).deliver
      respond_to do |format|
        format.js
      end
    end
  end

  #=================================================================================
  #  * Method name: share_restaurant_via_email
  #  * params input:  from, to, subject, message
  #  * Output: send email share to friend
  #  * Date modified: December 19, 2013
  #  * Description: share restaurant to friend
  #=================================================================================

  def share_restaurant_via_email
    if params[:email_pr]
      to = params[:email_pr][:to]
      from = params[:email_pr][:from]
      message = params[:email_pr][:message]
      url = params[:email_pr][:url]
      subject = params[:email_pr][:subject]
      @email = UserMailer.share_restaurant_email(to, from, subject, message, url).deliver
      respond_to do |format|
        format.js
      end
    end
  end

  #=================================================================================
  #  * Method name: change_status
  #  * Input: user_id, status
  #  * Output: list users
  #  * Date modified: August 26, 2012
  #  * Description: update status for user
  #=================================================================================
  def change_status
    @user = User.find(params[:id])
    if @user.change_status(params[:status])
      render template: "users/change_status"
    else
      render template: "users/change_status_error"
    end
  end

  def update_avatar
    @user = User.find(params[:id])
    if @user.update_without_password(params[:user])
      respond_to do |format|
        format.js
      end
    end
    
  end

  def toggle_gem_hunter
    @user = User.find_by_id(params[:id])
    if @user.present?
      status = params[:status].to_i == 1 ? true : false
      @user.update_gem_hunter(status, params[:gem_hunter_wordpress_url])
      # Wordpress.create_gem_hunter_wordpress(@user)
      # if(status == true)
      #   url = 'http://www.halalgems.com/author/' + @user.username
      #   @user.update_attribute('gem_hunter_wordpress_url', url )
      # end
    end
  end

end

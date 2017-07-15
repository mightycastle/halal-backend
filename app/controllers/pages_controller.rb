require 'rss'
class PagesController < ApplicationController

  before_filter :required_user_login, :only=>[:add_review, :personal_information, :create_review, :my_purchases]
  # before_filter :user_verified, :only=>[:add_review]
  layout "application_home", only: [:home]
  layout "application_none_bg", only: [:show_reviews]
  layout "faq_simple", only: [:faq_simple]

  MY_REVIEW_PER_PAGE = 30
  MY_FAVORITES_PER_PAGE = 30
  def home
    @admin_photo = AdminPhoto.ramdom_photo
    cuisine = Filter.cuisine.order("name ASC")
    filter = Filter.new(name:  t('choose_your_cuisine')) #t('all_cuisine')
    @cuisine = []
    @cuisine.push filter
    cuisine.each do |c|
      @cuisine.push c
    end
    @fetured_review = Review.get_lastest_gem_hunter(3)
    p "@fetured_review@fetured_review #{@fetured_review[1].to_json}"
    render :layout => 'application_home'
  end

  #=================================================================================
  #  * Method name: restaurant
  #  * Input: params page, restaurant_id
  #  * Output: restaurant info, reviews of the restaurant
  #  * Date modified: August 26, 2012
  #  * Description:
  #=================================================================================
  def restaurant

  end
#  def download_menu

#    #send_file "menu.pdf"
#    send_file("#{Rails.root}/public/menu.pdf", {:type=>'application/pdf',
#      :disposition => "attachment", :filename=>"menu.pdf"})
#  end

  def about_us
    @page = BasicsPage.find(1)
  end

  def how_it_works
    @page = BasicsPage.find(3)
  end
  #=================================================================================
  #  * Method name: contact_us
  #  * Input: Name, Email, Message
  #  * Output: System send out and message to halalgems email
  #  * Date modified: September 05, 2012
  #  * Description:
  #=================================================================================
  def contact_us
    @page = BasicsPage.find(2)
  end
  def send_contact_message
    if simple_captcha_valid?
      email = EMAIL_CONTACT_US
      guest_name = params[:name]
      guest_email = params[:email]
      content = params[:message]
      if UserMailer.send_contact_message(email,guest_name,guest_email,content).deliver
        flash[:success] = "Thanks for your message!"
        redirect_to contact_us_path
      else
        flash[:notice] = "Oops, please try again"
        @page = BasicsPage.find(2)
        render :contact_us
      end
    else
      flash[:error] = "Captcha is not valid!"
      @page = BasicsPage.find(2)
      render :contact_us
    end
  end
  def registered
  end
  #=================================================================================
  #  * Method name: advertise_your_restaurant
  #  * Input: name, restaurant_name, email, phone
  #  * Output: System send out and message to halalgems email
  #  * Date modified:
  #  * Description:
  #=================================================================================
  def advertise_your_restaurant
    # @page = BasicsPage.find(2)
  end
  def send_advertise_restaurant_message
    if simple_captcha_valid?
      email = EMAIL_CONTACT_US
      name = params[:name]
      guest_email = params[:email]
      restaurant_name = params[:restaurant_name]
      phone = params[:phone]
      if UserMailer.send_contact_message(email, name, guest_email, restaurant_name, phone).deliver
        flash[:success] = "Thanks for your message!"
        redirect_to advertise_your_restaurant_path
      else
        flash[:notice] = "Opz, please try again"
        render :advertise_your_restaurant
      end
    else
      flash[:error] = "Captcha is not valid!"
      render :advertise_your_restaurant
    end
  end

  #=================================================================================
  #  * Method name: faq
  #  * Input:
  #  * Output:
  #  * Date modified: September 05, 2012
  #  * Description:
  #=================================================================================
  def faq
    @page = BasicsPage.find(4)
  end
  def send_direction
    flash[:notice] = t(:send_direction_message)
    UserMailer.send_direction(params[:email],Restaurant.find(params[:restaurant_id]), params[:direction_content]).deliver
  end
  #=================================================================================
  #  * Method name: faq_simple
  #  * Input:
  #  * Output:
  #  * Date modified: December 30, 2015
  #  * Description:
  #=================================================================================
  def faq_simple
    @page = BasicsPage.find(4)
  end
  #=================================================================================
  #  * Method name: add_review
  #  * Input: current_user
  #  * Output: new review
  #  * Date modified: September 05, 2012
  #  * Description:
  #=================================================================================
  def add_review
    @review = Review.new
    @user_id = current_user ? current_user.id : 0
    @restaurant_id = params[:restaurant_id]
    @restaurant = Restaurant.find(@restaurant_id)
    if @user_id.to_i == 0
      flash[:notice] = "You do not login. Please log in to add your comment."
      redirect_to :back
    end
  end


  def refresh_captcha
    respond_to do |format|
      format.js   # refresh_captcha.js.erb
    end
  end
  #=================================================================================
  #  * Method name: more_reviews
  #  * Input: page_num, restaurant_id
  #  * Output: restaurant, reviews of the restaurant
  #  * Date modified: September 05, 2012
  #  * Description:
  #=================================================================================
  def show_reviews
    # @type = params[:type] || ''
    # @page_num = params[:page_num].to_i
    @restaurant = Restaurant.find(params[:restaurant_id])
    sort_by = params[:sort_by] ||= "created_at DESC"
    # @reviews = @restaurant.reviews.approved.order(sort_by).page @page_num
    @reviews = @restaurant.reviews.approved.order(sort_by)
    # @total_page = @reviews.total_pages
    respond_to do |format|
      format.html
      format.js
    end
    # render :layout => 'application_none_bg'
  end
  #=================================================================================
  #  * Method name: more_reviews
  #  * Input: page_num, restaurant_id
  #  * Output: restaurant, reviews of the restaurant
  #  * Date modified: September 05, 2012
  #  * Description:
  #=================================================================================
  def show_reviews_sorted
    @type = params[:type] || ''
    @page_num = params[:page_num].to_i || 1
    @per_page = @page_num*10
    @restaurant = Restaurant.find(params[:restaurant_id])
    @sort_by = params[:sort_by] ||= "created_at DESC"
    @reviews = @restaurant.reviews.approved.order(@sort_by).limit(@per_page)
    @total_page = @restaurant.reviews.approved.count
    p "==================================="
    p @reviews.count
    respond_to do |format|
      format.js
    end
    # render :layout => 'application_none_bg'
  end
  #=================================================================================
  #  * Method name: newsletter
  #  * Input: param email
  #  * Output: add email to mailchip list
  #  * Date modified: September 06, 2012
  #  * Description:
  #=================================================================================
  def newsletter
    email = params[:notice][:email]
    @success = false
    if !email.blank?
      begin
        mailchimp = Hominid::API.new(Devise.mailchimp_api_key)
        list_id = mailchimp.find_list_id_by_name(GET_OFFER_LIST_EMAIL)
        info = { }
        result = mailchimp.list_subscribe(list_id, email, info, 'text', false, true, false, true)
      #Rails.logger.info("MAILCHIMP SUBSCRIBE: result #{result.inspect} for #{self.email}")
      #puts "result: #{result.inspect}"
#      user = User.last
#      user.email = email
#      result = user.add_to_mailchimp_list(Devise.mailing_list_name)
      rescue Exception =>ex
        result = nil
      end
      @is_newsletter = true
      @notice = ''
      if result
        @notice = view_context.notice_newsletter.html_safe
        @success = true
      else
        @notice = I18n.t('signup.newsletter_unsucsess')
      end
    else
      @notice = 'Please type your email'
    end
    respond_to do |format|
      format.js
    end
  end


  def terms_conditions
    @page = BasicsPage.find(5)
  end
  #=================================================================================
  #  * Method name: personal_information
  #  * Input:
  #  * Output:
  #  * Date modified: September 05, 2012
  #  * Description:
  #=================================================================================
  def personal_information
    @user = User.find(current_user.id)
    @tab_name = params[:tab_name]
    @reviews = Review.where(:user_id=>current_user.id).order("created_at DESC").page(params[:page]).per(1)
    @restaurants = Restaurant.my_favourite(current_user.id).page(params[:page]).per(MY_FAVORITES_PER_PAGE)

    respond_to do |format|
      format.html
      format.js
    end
  end
  #=================================================================================
  #  * Method name: personal_information
  #  * Input:
  #  * Output:
  #  * Date modified: September 05, 2012
  #  * Description:
  #=================================================================================
  def my_purchases
    @subscriptions = current_user.subscriptions.order("created_at DESC").page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.js
    end
  end
  #=================================================================================
  #  * Method name: update_personal_information
  #  * Input: Fullname (first, middle and last name), email, phone, avatar(optional)
  #  * Output: System save all information
  #  * Date modified: September 05, 2012
  #  * Description:
  #=================================================================================
  def update_personal_information
    password_changed = !params[:user][:password].blank?

    begin
      if params[:user][:is_subscribed] == "0"
        current_user.remove_from_mailchimp_list(GET_OFFER_LIST_EMAIL)
      else
        current_user.add_to_mailchimp_list(GET_OFFER_LIST_EMAIL)
      end
    rescue Exception=>ex
    end

    successfully_updated = if password_changed
      current_user.update_attributes(params[:user])
    else
      current_user.update_without_password(params[:user])
    end

    if successfully_updated
      flash[:notice] = "Your personal information has been updated successfully!"
      sign_in current_user, :bypass => true
    else
      flash[:error] = current_user.errors.full_messages
    end
    redirect_to personal_information_path
  end

  def dashboard
  end

  def add_email_landing
    email  = params[:user][:email]
    user =  User.new(email: email)
    user.add_to_mailchimp_list(Devise.mailing_list_name)
    redirect_to root_path
  end
end

class RestaurantsController < ApplicationController
  # GET /restaurants
  # GET /restaurants.json
  layout 'admin', :except => ['new', 'create', 'show', 'offer']
  before_filter :authenticate_user!, :required_user_login, except: [:show, :new, :create]
  before_filter :authenticate_user!, :require_profession_user, only:[:create_offer, :offer, :update_social_link]
  before_filter :authenticate_user!, :required_restaurant_owner_role, only: [:restaurant_managerment,:offer, :update_social_link]
  before_filter :authenticate_user!, :required_admin_role,
                only: [:admin_new, :index, :approve_change, :reject_change, :disable_toggle, :collections, :admin_new_collection, :change_photo_request, :edit, :update]

  autocomplete :user, :username, :full => true, :display_value => :username_email, :extra_data => [:email]
  autocomplete :restaurant, :name, :full => true, :display_value => :restaurant_name, :extra_data => [:id]

  REVIEW_PER_PAGE = 10
  def index
    # filter_id = params[:filter_id] || 0
    # search = Restaurant.filter_restaurant(filter_id)
    # @search = search.search(params[:q])
    @search = Restaurant.search(params[:q])
    result = @search.result
    @restaurants = result.order("disabled ASC,created_at DESC").page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @restaurants }
    end
  end

  def change_photo_request
    @search = Restaurant.search(params[:q])
    @restaurants = @search.result.order('request_approve_photo DESC, updated_at DESC, disabled ASC').find_all { |r| r.photos.count > 0 }
    @restaurants = Kaminari.paginate_array(@restaurants).page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @restaurants }
    end
  end

  def offer
    @restaurant = Restaurant.find(params[:id])
    if(current_user.restaurants && current_user.restaurant_ids.include?(@restaurant.id))
      @offer = Offer.new
      respond_to do |format|
        format.html
      end
    else
      redirect_to root_path
    end
  end

  def approve_change
    @restaurant_temp = RestaurantTemp.find(params[:id])
    params = @restaurant_temp.attributes
    @restaurant = Restaurant.find(@restaurant_temp.restaurant_id)
    params.delete "restaurant_id"
    params.delete "id"
    params.delete "created_at"

    if @restaurant.update_attributes!(params)
      @schedules_res = Schedule.where(restaurant_id: @restaurant.id)
      if @schedules_res.length > 0
        @schedules_res.each do |s_r|
          s_r.destroy
        end
      end
      @schedules = Schedule.where(restaurant_temp_id: @restaurant_temp.id)
      if @schedules.length > 0
        @schedules.each do |s|
          s.restaurant_temp_id = nil
          s.restaurant_id = @restaurant.id
          s.save
        end
      end
      @photos = @restaurant_temp.photos
      if @photos.length > 0
        @photos.each do |p|
          p.restaurant_temp_id = nil
          p.restaurant_id = @restaurant.id
          p.save
        end
      end
      @restaurant.filter_ids = @restaurant_temp.filter_ids
      @restaurant.save
      @rest_temp_id = @restaurant_temp.id
      @restaurant_temp.destroy
      respond_to do |format|
        format.js
      end
    end

  end

  def reject_change
    @restaurant_temp = RestaurantTemp.find(params[:id])
    @restaurant_temp.photos.destroy
    @restaurant_temp.destroy
    @rest_temp_id = @restaurant_temp.id
    email = @restaurant_temp.user.email if !@restaurant_temp.user.nil?
    UserMailer.send_reject_restaurant_update(email,@restaurant_temp).deliver
    respond_to do |format|
      format.js
    end
  end


  def restaurant_managerment
    check_params(params)
    @restaurant_temp = RestaurantTemp.where(restaurant_id: params[:id]).first
    @restaurant = Restaurant.find(params[:id])
    unless @restaurant_temp
      param_attr = @restaurant.dup.attributes
      param_attr.delete "created_at"
      param_attr.delete "updated_at"
      param_attr.delete "service_avg"
      param_attr.delete "quality_avg"
      param_attr.delete "rating_avg"
      param_attr.delete "value_avg"
      param_attr.delete "menu_uid"
      param_attr.delete "menu_name"
      param_attr.delete "menus"
      param_attr.delete "waiting_for_approve_change"
      param_attr.delete "request_approve_photo"
      param_attr[:restaurant_id] = @restaurant.id
      @restaurant_temp = RestaurantTemp.create(param_attr)
    end
    params[:restaurant][:filter_ids] << params[:restaurant][:filter_id_shisha] if params[:restaurant][:filter_id_shisha]
    params[:restaurant][:filter_ids] << params[:restaurant][:filter_id_alcohol] if params[:restaurant][:filter_id_alcohol]
    params[:restaurant][:filter_ids] << params[:restaurant][:filter_id_price] if params[:restaurant][:filter_id_price]
    params[:restaurant].delete 'filter_id_shisha'
    params[:restaurant].delete 'filter_id_alcohol'
    params[:restaurant].delete 'filter_id_price'
    if params[:restaurant][:filter_ids] != nil
      @restaurant_temp.filter_ids = params[:restaurant][:filter_ids]
      @restaurant_temp.save
    end
    respond_to do |format|
      if params[:restaurant][:image].present?
        params[:image] = []
        params[:image] = params[:restaurant][:image]
        params[:restaurant].delete "image"
      end
      schedules = @restaurant_temp.schedules
      if schedules
        schedules.each do |sch|
          sch.destroy
        end
      end
      params[:restaurant][:schedules_attributes].each do |a|
        a[1].delete 'id'
      end

      if @restaurant_temp.update_attributes(params[:restaurant])
        if params[:image].present?
          if params[:image].class.to_s == "ActionDispatch::Http::UploadedFile"
            @p = @restaurant_temp.photos.create(image: params[:image], restaurant_temp_id: @restaurant_temp.try(:id), :user_id => current_user.id)
          else
            @restaurant_temp.photos.create(image: ActionDispatch::Http::UploadedFile.new(params[:image]), restaurant_temp_id: @restaurant_temp.try(:id), :user_id => current_user.id)
          end
        end
      end
      format.html { redirect_to edit_user_restaurant_path(@restaurant.slug), notice: I18n.t('restaurant.update_wait_approve') }
      format.json { head :no_content }
    end
  end

  def report
    if current_user
      @no_report_info = false
      reasons = []
      reasons.push("Is closed") if params[:is_closed]
      reasons.push("Has incorrect information") if params[:has_incorrect_information]
      more_details = params[:more_details]
      if reasons.count == 0 && more_details.blank?
        @no_report_info = true
      else
        email = EMAIL_CONTACT_US
        user_email = current_user.email
        restaurant = Restaurant.find_by_id(params[:restaurant_id])
        restaurant_name = restaurant.name
        @delivered = UserMailer.send_report_restaurant_message(email, user_email, restaurant_name, reasons, more_details).deliver
      end
    end
    respond_to do |format|
      format.js
    end
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
    @page = params[:page] || 1
    @per_page = REVIEW_PER_PAGE
    @restaurant = Restaurant.find(params[:id])
    # @restaurant = Restaurant.find_by_slug(params[:id]) if @restaurant.nil?

    if @restaurant.present?
      @gem_hunter = @restaurant.random_gem_hunter
      @group_hours = Schedule.restaurant_group_open_hours(@restaurant.id)
      @click = false
      if current_user.blank?
        @favourite_or_not = false
      else
        @favourite_or_not = current_user.favourite_or_not?(@restaurant.id)
      end
      if @gem_hunter.present?
        p "============================================="
        @reviews = @restaurant.normal_reviews.limit(4) || []
      else
        @reviews = @restaurant.normal_reviews.limit(6) || []
      end
      p "@reviews@reviews@reviews #{@reviews.to_json}"
      @reviews_count = @restaurant.reviews.approved.count
      respond_to do |format|
        if current_user && @restaurant.user_id == current_user.id
          format.html{ render 'user_restaurants'}
        else
          format.html
          format.js   # restaurant.js.erb
        end

      end
    else
      respond_to do |format|    format.html { render :nothing => true } end
    end
  end

  # GET /restaurants/new
  # GET /restaurants/new.json
  def new
    @restaurant = Restaurant.new
    @restaurant.reviews.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @restaurant }
    end
  end

  def admin_new        
    build_new_restaurant
  end
  # GET /restaurants/1/edit
  def edit
    @restaurant = Restaurant.find(params[:id])

    if @restaurant.schedules.blank?
      (1..7).each {|i| @restaurant.schedules.build(day_of_week: i)}
    elsif @restaurant.schedules.is_daily.blank?
      (1..7).each {|i| @restaurant.schedules.build(day_of_week: i, schedule_type: 'daily')}
    elsif @restaurant.schedules.is_evening.blank?
      (1..7).each {|i| @restaurant.schedules.build(day_of_week: i, schedule_type: 'evening')}
    end
    @restaurant.photos.build if @restaurant.photos.blank?
    cuisine = @restaurant.filters.where(code: 'cuisine')
    @filter_cuisine_id = []
    if cuisine.length > 0
      cuisine.each do |c| @filter_cuisine_id << c.id end
    end

    @menu = Menu.new(restaurant_id: @restaurant.id)
    @filter_ids = @restaurant.filter_ids

    filter_type_hal_status = FilterType.where(code: 'hal_status').first
    @filter_status = filter_type_hal_status.filters if filter_type_hal_status

    # filter_type_facilities = FilterType.where(code: 'facility').first
    # @filter_facilities = filter_type_facilities.filters if filter_type_facilities

    filter_type_price = FilterType.where(code: 'price').first
    @filter_prices = filter_type_price.filters if filter_type_price

    filter_type_cuisine = FilterType.where(code: 'cuisine').first
    @filter_cuisines = filter_type_cuisine.filters.order('name ASC') if filter_type_cuisine

    filter_type_alcohol = FilterType.where(code: 'alcohol').first
    @filter_alcohol = filter_type_alcohol.filters if filter_type_alcohol

    # filter_type_shisha = FilterType.where(code: 'shisha').first
    # @filter_shisha = filter_type_shisha.filters if filter_type_shisha

    # filter_type_organic = FilterType.where(code: 'organic').first
    # @filter_organic = filter_type_organic.filters if filter_type_organic

    filter_type_features = FilterType.where(code: 'features').first
    @filter_features = filter_type_features.filters.where_not_offer if filter_type_features
  end

  # create info user restaurant
  def create_user_restaurant


  end
  # create a review for restaurant
  def create_review
    @restaurant_id = params[:id]
    @restaurant = Restaurant.find(@restaurant_id)
    @review = @restaurant.reviews.build(params[:review])
    @review.visited_date = DateTime.new(params[:date][:year].to_i, params[:date][:month].to_i, 15)
    @review.user_id = current_user.id
    @review.terms_conditions = params[:terms_conditions]
    respond_to do |format|
      if params[:review][:service].to_i == 0 || params[:review][:quality].to_i == 0 || params[:review][:value].to_i == 0
        flash[:error_rating] = I18n.t("review.missing_rating")
      end
      if params[:review][:content].blank?
        flash[:error_content] = I18n.t("review.missing_content")
      end
      if @review.save
        format.html { redirect_to restaurant_info_path(@review.restaurant.slug), notice: I18n.t('review.create_success') }
        format.json { render json: @review, status: :created, location: @review }
      else
        format.html { redirect_to restaurant_info_path(@review.restaurant.slug) }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

# update social link for restaurant
  def update_social_link
    @restaurant = current_user.restaurants.find(params[:id])
    @restaurant.update_attributes(params[:restaurant])
    respond_to do |format|
      format.js
    end
  end


  # POST /restaurants
  # POST /restaurants.json
  def create
    if params[:check_user] == 'true'
      params[:restaurant].delete 'reviews_attributes'
    elsif params[:restaurant][:reviews_attributes] && current_user.blank?
      session[:review] = params[:restaurant][:reviews_attributes]["0"]
      session[:date] = params[:date].present? ? params[:date] : ''
      params[:restaurant].delete 'reviews_attributes'
    elsif params[:restaurant][:reviews_attributes] && current_user.present?
      params[:restaurant][:reviews_attributes]["0"][:user_id] = current_user.id if current_user
    end

    if params[:admin] == 'true'
      params[:restaurant][:filter_ids] = [] if params[:restaurant][:filter_ids].nil?
      params[:restaurant][:filter_ids] << params[:restaurant][:filter_id_shisha] if params[:restaurant][:filter_id_shisha]
      params[:restaurant][:filter_ids] << params[:restaurant][:filter_id_price] if params[:restaurant][:filter_id_price]
      params[:restaurant].delete 'filter_id_shisha'
      params[:restaurant].delete 'filter_id_price'
    end
    @restaurant = Restaurant.where(name: params[:restaurant][:name]).first
    respond_to do |format|
      if @restaurant.blank?
        @restaurant = Restaurant.new(params[:restaurant])
        if @restaurant.save
          session[:restaurant_id] = @restaurant.id
          if @restaurant.user
            user = @restaurant.user
            user.set_restaurant_owner_role()
            user.add_to_mailchimp_list(MAILING_LIST_OWNER)
          end
          unless params[:menus].nil?
            params[:menus].each do |m|
              @restaurant.menus << Menu.create(:menu => m,  :user_id=>current_user.id)
            end
          end
        else
          format.html { render action: "new" }
          format.json { render json: @restaurant.errors, status: :unprocessable_entity }
        end
      elsif params[:admin] == 'true'
        # cheat to keep input value retain
        build_new_restaurant(params[:restaurant], params[:location_search])
        flash[:error] = I18n.t('restaurant.restaurant_exist')
        render 'restaurants/admin_new', layout: 'admin'
        return
      elsif current_user.present? && params[:restaurant][:reviews_attributes]["0"].present?
        @review = @restaurant.reviews.build(params[:restaurant][:reviews_attributes]["0"])
        @review.visited_date = DateTime.new(params[:date][:year].to_i, params[:date][:month].to_i,15)
        @review.user_id = current_user.id
        @review.terms_conditions = params[:terms_conditions]
        @review.save!
      else
        session[:restaurant_id] = @restaurant.id
        session[:review] = params[:restaurant][:reviews_attributes]["0"] if params[:restaurant][:reviews_attributes].present?
        session[:date] = params[:date].present? ? params[:date] : ''
      end
      # response
      if current_user.nil? && session[:review].present?
        format.html { redirect_to root_path, notice: I18n.t('restaurant.create_success_and_confirm_review') }
      elsif current_user.present? && current_user.is_admin_role?
        format.html { redirect_to admin_path, notice: I18n.t('restaurant.create_by_admin_success') }
      elsif params[:check_user] == 'true'
        format.html { redirect_to root_path, notice: I18n.t('restaurant.create_by_owner_success') }
      else
        format.html { redirect_to root_path, notice: I18n.t('restaurant.create_success') }
      end
    end
  end


  # PUT /restaurants/1
  # PUT /restaurants/1.json
  def update
    check_params(params)
    @restaurant = Restaurant.find(params[:id])
    params[:restaurant][:filter_ids] = [] if params[:restaurant][:filter_ids].nil?
    params[:restaurant][:filter_ids] << params[:restaurant][:filter_id_shisha] if params[:restaurant][:filter_id_shisha]
    params[:restaurant][:filter_ids] << params[:restaurant][:filter_id_price] if params[:restaurant][:filter_id_price]
    params[:restaurant].delete 'filter_id_shisha'
    params[:restaurant].delete 'filter_id_price'
    respond_to do |format|
      if @restaurant.update_attributes(params[:restaurant])
        if @restaurant.user
          user = @restaurant.user
          user.set_restaurant_owner_role()

          user.add_to_mailchimp_list(MAILING_LIST_OWNER)
        end
        unless params[:menus].nil?
          params[:menus].each do |m|
            @restaurant.menus << Menu.create(:menu => m,  :user_id=>current_user.id)
          end
        end
        format.html { redirect_to edit_restaurant_path(@restaurant.slug), notice: I18n.t('restaurant.update_success') }
        format.json { head :no_content }
      else
        @menu = Menu.new(restaurant_id: @restaurant.id)
        format.html { redirect_to edit_restaurant_path(@restaurant.slug) }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy

    respond_to do |format|
      format.html { redirect_to restaurants_url }
      format.json { head :no_content }
    end
  end


  #=================================================================================
  #  * Method name: disable_toggle
  #  * Input: restaurant_id
  #  * Output: disable/enable restaurant
  #  * Date modified: August 27, 2012
  #  * Description:
  #=================================================================================
  def disable_toggle
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.disable_toggle
      render template: "restaurants/disable_toggle"
    else
      render template: "restaurants/disable_toggle_error"
    end
  end
  #=================================================================================
  #  * Method name: add_favourite
  #  * Input: current_user, restaurant_id
  #  * Output: add favourite for a restaurant
  #  * Date modified: August 27, 2012
  #  * Description: user add favourite in a restaurant
  #=================================================================================
  def add_favourite
    if current_user.is_verified? &&
      Favourite.create(user_id: current_user.id, restaurant_id: params[:id])

      @favourite_or_not = true
      @click = true
      @restaurant = Restaurant.find(params[:id])
      #flash.now[:notice] = I18n.t('restaurant.add_favourite')
      render template: "restaurants/add_favourite"
    else
      render template: "restaurants/add_favourite_error"
    end
  end
  #=================================================================================
  #  * Method name: remove_favourite
  #  * Input: current_user, restaurant_id
  #  * Output: remove favourite for a restaurant
  #  * Date modified: August 27, 2012
  #  * Description: user add favourite in a restaurant
  #=================================================================================
  def remove_favourite
    favourite = Favourite.find_by_user_id_and_restaurant_id(current_user.id,params[:id])
    favourite.destroy if favourite.present?

    if (favourite.blank? && params[:id].present?) || favourite.destroyed?
      @favourite_or_not = false
      @click = true
      #flash.now[:notice] = I18n.t('restaurant.remove_favourite')
      @restaurant = Restaurant.find(params[:id])
      render template: "restaurants/add_favourite"
    else
      render template: "restaurants/add_favourite_error"
    end
  end
  #=================================================================================
  #  * Method name: remove_favourite
  #  * Input: restaurant id
  #  * Output:
  #  * Date modified: September 05, 2012
  #  * Description:
  #=================================================================================
  # def remove_my_favourite
  #   favourite = Favourite.find_by_user_id_and_restaurant_id(current_user.id,params[:id])
  #   if favourite.destroy && favourite.save
  #     @id = params[:id]
  #     render template: "restaurants/remove_favourite"
  #   else
  #     render template: "restaurants/remove_favourite_error"
  #   end
  # end

  def check_params(params)
    params[:restaurant][:email] = "" if params[:restaurant][:email] == "Email"
    params[:restaurant][:phone] = "" if params[:restaurant][:phone] == "Phone"
    params[:restaurant][:name] = "" if params[:restaurant][:name] == "Name"
    params[:restaurant][:address] = "" if params[:restaurant][:address] == "Location"
    params[:restaurant][:short_address] = "" if params[:restaurant][:short_address] == "Address"
    params[:restaurant][:website] = "" if params[:restaurant][:website] == "Website"
    params[:restaurant][:city] = "" if params[:restaurant][:city] == "City"
    params[:restaurant][:district] = "" if params[:restaurant][:district] == "District"
    params[:restaurant][:country] = "" if params[:restaurant][:country] == "Country"
    params[:restaurant][:lat] = "" if params[:restaurant][:lat] == "Latitude"
    params[:restaurant][:lng] = "" if params[:restaurant][:lng] == "Longitude"
  end

  def build_new_restaurant(options={}, location_search='')
    @restaurant = Restaurant.new(options)
    @restaurant.build_new_timesheets
    @restaurant.build_new_photo
    @location_search = location_search
    get_filters
  end  

  def get_filters
    # cuisine = @restaurant.filters.where(code: 'cuisine').first

    @menu = Menu.new(restaurant_id: @restaurant.id)
    @filter_ids = @restaurant.filter_ids

    filter_type_hal_status = FilterType.where(code: 'hal_status').first
    @filter_status = filter_type_hal_status.filters if filter_type_hal_status

    # filter_type_facilities = FilterType.where(code: 'facility').first
    # @filter_facilities = filter_type_facilities.filters if filter_type_facilities

    filter_type_price = FilterType.where(code: 'price').first
    @filter_prices = filter_type_price.filters if filter_type_price

    filter_type_cuisine = FilterType.where(code: 'cuisine').first
    @filter_cuisines = filter_type_cuisine.filters.order('name ASC') if filter_type_cuisine

    filter_type_alcohol = FilterType.where(code: 'alcohol').first
    @filter_alcohol = filter_type_alcohol.filters if filter_type_alcohol

    # filter_type_shisha = FilterType.where(code: 'shisha').first
    # @filter_shisha = filter_type_shisha.filters if filter_type_shisha

    # filter_type_organic = FilterType.where(code: 'organic').first
    # @filter_organic = filter_type_organic.filters if filter_type_organic

    filter_type_features = FilterType.where(code: 'features').first
    @filter_features = filter_type_features.filters.where_not_offer if filter_type_features
  end

  # =================================================================================
  # COLLECTIONS
  # =================================================================================
  # =================================================================================
  #  * Method name: collections
  #  * Input:
  #  * Output: Collection name, Collection description, Collection image_url
  #  * Date modified: January 12, 2016
  #  * Description: Pulls data about collections and paginates results in table
  # =================================================================================

  def collections
    @search = Collection.search(params[:q])
    @collections = @search.result.order("name ASC, created_at DESC").page(params[:page])
    @collections = Kaminari.paginate_array(@collections).page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collections }
    end
  end

  # =================================================================================
  #  * Method name: admin_new_collection
  #  * Input: Collection name, Collection description, Collection image_url
  #  * Output:
  #  * Date modified: January 12, 2016
  #  * Description: Allows the administrator adding new collections
  # =================================================================================
  # GET /restaurants/admin_new_collection
  # GET /restaurants/admin_new_collection.json
  def admin_new_collection
    @collection = Collection.new

    respond_to do |format|
      format.html # new_collection.html.erb
      format.json { render json: @collection }
    end
  end

  # =================================================================================
  #  * Method name: admin_new_collection
  #  * Input:
  #  * Output: Collection name, Collection description, Collection image_url
  #  * Date modified: January 14, 2016
  #  * Description: Allows the administrator editing collections
  # =================================================================================
  # GET /restaurants/collection/1/edit
  def edit_collection
    @collection = Collection.find(params[:id])
  end
end

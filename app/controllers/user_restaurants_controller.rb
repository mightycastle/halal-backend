class UserRestaurantsController < ApplicationController
  before_filter :required_user_login, only: [:edit]
  include RestaurantsHelper
#  before_filter :authenticate_user!

  #=================================================================================
  #  * Method name: index
  #  * Input: current_user
  #  * Output: list restaurants belongs to current_user
  #  * Date modified: August 31, 2012
  #  * Description: get list restaurants 
  #=================================================================================
  def index
    if current_user.admin_role
      redirect_to restaurants_path
    elsif current_user.restaurants
      @restaurant = current_user.restaurants.first
      redirect_to user_restaurant_path(@restaurant.slug)
    else
      redirect_to new_user_restaurant_path
    end
  end

  #=================================================================================
  #  * Method name: index
  #  * Input: current_user
  #  * Output: list restaurants belongs to current_user
  #  * Date modified: August 31, 2012
  #  * Description: get list restaurants 
  #=================================================================================
  def my_favourite
    @restaurants = Restaurant.my_favourite(current_user.id)
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show

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

  # GET /user_restaurants/1/edit
  def edit
    @restaurant = Restaurant.find(params[:id])
    detect_owner
    if @restaurant.schedules.blank?
      (1..7).each {|i| @restaurant.schedules.build(day_of_week: i)} 
    elsif @restaurant.schedules.is_daily.blank?
      (1..7).each {|i| @restaurant.schedules.build(day_of_week: i, schedule_type: 'daily')} 
    elsif @restaurant.schedules.is_evening.blank?
      (1..7).each {|i| @restaurant.schedules.build(day_of_week: i, schedule_type: 'evening')} 
    end

    @restaurant.photos.build if @restaurant.photos.blank?

    @menu = Menu.new(restaurant_id: @restaurant.id)
    cuisine = @restaurant.filters.where(code: 'cuisine')
     @filter_cuisine_id = []
    if cuisine.length > 0
      cuisine.each do |c| @filter_cuisine_id << c.id end
    end
    
    @filter_ids = @restaurant.filter_ids

    filter_type_hal_status = FilterType.where(code: 'hal_status').first
    @filter_status = filter_type_hal_status.filters if filter_type_hal_status


    filter_type_price = FilterType.where(code: 'price').first
    @filter_prices = filter_type_price.filters if filter_type_price

    # filter_type_facilities = FilterType.where(code: 'facility').first
    # @filter_facilities = filter_type_facilities.filters if filter_type_facilities

    filter_type_cuisine = FilterType.where(code: 'cuisine').first
    @filter_cuisines = filter_type_cuisine.filters.order('name ASC') if filter_type_cuisine

    # filter_type_shisha = FilterType.where(code: 'shisha').first
    # @filter_shisha = filter_type_shisha.filters if filter_type_shisha
    
    filter_type_alcohol = FilterType.where(code: 'alcohol').first
    @filter_alcohol = filter_type_alcohol.filters if filter_type_alcohol

    # filter_type_organic = FilterType.where(code: 'organic').first
    # @filter_organic = filter_type_organic.filters if filter_type_organic

    filter_type_features = FilterType.where(code: 'features').first
    @filter_features = filter_type_features.filters.where_not_offer if filter_type_features
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    
    @restaurant = Restaurant.new(params[:restaurant])
    
    # ok = false
    
    # unless current_user 
    #   if simple_captcha_valid?
    #     ok = true if @restaurant.save
    #   else
    #     @error = 'Captcha invalid'  
    #   end
    # else 
    #   ok = true if @restaurant.save
    # end
    
    respond_to do |format|
      if @restaurant.save!
        format.html { redirect_to root_path, notice: I18n.t('suggestion.create_success') }
        format.json { render json: @restaurant, status: :created, location: @restaurant }
      else
        format.html { render action: "new" }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /restaurants/1
  # PUT /restaurants/1.json
  def update
    @restaurant = Restaurant.find(params[:id])

    respond_to do |format|
      if @restaurant.update_attributes(params[:restaurant])
        format.html { redirect_to user_restaurant_path(@restaurant.slug), notice: I18n.t('restaurant.update_success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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

  
  private
  def detect_owner
    unless is_owner_restaurant?(current_user, @restaurant)
      redirect_to "/"
      return
    end
  end

end

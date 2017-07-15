class Restaurant < ActiveRecord::Base
  include Grape::Entity::DSL
  include FriendlyId
  geocoded_by :address, :latitude  => :lat, :longitude => :lng

  # ============================================================================
  # BEFORE ACTION
  # ============================================================================
  before_save :update_filter_type_ids
  #  after_save :change_price_range

  #image_accessor :menu
  attr_accessor :user_name
  attr_accessible :address, :deliverable, :description, :disabled, :email,
                  :name, :phone, :shisha_allow, :user_id, :lat, :lng, :district,
                  :city, :postcode, :country, :direction, :filter_ids, :price,
                  :menus, :filter_type_ids, :schedules_attributes, :contact_note, :slug,
                  :suggester_name, :is_owner, :website, :halal_status, :short_address, :user_name,
                  :special_deal, :reviews_attributes, :facebook_link, :twitter_link, :pinterest_link, :waiting_for_approve_change, :updated_at,
                  :photos, :suggester_email, :suggester_phone, :request_approve_photo, :instagram_link, :filter_id_alcohol


  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :offers, dependent: :destroy

  has_and_belongs_to_many :filters
  has_and_belongs_to_many :filter_types
  has_and_belongs_to_many :collections, :join_table => "collection_restaurants"
  has_many :favourites, dependent: :destroy
  has_many :menus, dependent: :destroy

  has_many :checkins, dependent: :destroy

  # ============================================================================
  # ATTRIBUTES
  # ============================================================================
  friendly_id :name, :use => :slugged

  accepts_nested_attributes_for :schedules
  accepts_nested_attributes_for :reviews

  # ============================================================================
  # SCOPE
  # ============================================================================
  scope :enabled, where(:disabled => false)
  scope :have_offer, includes(:offers).where("offers.approve" => true)
  scope :my_favourite , lambda{ |user_id|
          joins(:favourites).where("favourites.user_id = ?", user_id) unless user_id.nil? }

  # ============================================================================
  # ENUM
  # ============================================================================
  # Setup searchable attributes for user model
  RANSACKABLE_ATTRIBUTES = ["name", "email", "phone", "website", "address", "district",
                            "city", "postcode", "country", "user_username", 'description', "disabled", "created_at"]
  SORT_BY = {
    rating: "Recommended",
    name: "Name",
    price_low: "price (low to high)",
    price_high: "price (high to low)",
    distance: "Distance"
  }

  ZOOM_LEVEL = {
    0 => 24000 ,
    1 => 12000,
    2 => 6000,
    3 => 3000,
    4 => 1500,
    5 => 700,
    6 => 320,
    7 => 160,
    8 => 80,
    9 => 40,
    10 => 20,
    11 => 10,
    12 => 5,
    13 => 2.5,
    14 => 1.3,
    15 => 0.7,
    16 => 0.4,
    17 => 0.25,
    18 => 0.13,
    19 => 0.08,
    20 => 0.04,
    21 => 0.02
  }

  # FILTER_TYPE_PRICE_ID = FilterType.where(code: 'price').first.id if FilterType.where(code: 'price').first.present? && FilterType.where(code: 'price').first.present?
  # FILTER_PRICE_IDS = Filter.price.map {|ft| ft.id}
  OFFER_ID = ''
  if FilterType.offer.present? && Filter.offer.present?
    Filter.offer.first.id
    FilterType.offer.first.id
    OFFER_ID = "#{Filter.offer.first.id},#{FilterType.offer.first.id}"
  end
  RESTAURANT_PER_PAGE = 18

  #get favourite restaurants of current_user
  # ============================================================================
  # VALIDATE
  # ============================================================================
  validates :name, :presence => true
  validates :slug, :presence => true, :uniqueness => true, :on => :update
  validates :phone, :format => { :with => /\A\S[0-9\+\/\(\)\s\-]*\z/i, message: I18n.t("errors.invalid_phone") }, :allow_blank => true
  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :on => :create, message: I18n.t("errors.invalid_email") }, :allow_blank => true
  validates :suggester_email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :on => :create, message: I18n.t("errors.invalid_suggester_email") }, :allow_blank => true

  # ============================================================================
  # ENTITY
  # ============================================================================

  entity do

    expose :lambda_id, as: :id,
      if: lambda { |restaurant, options| true } do |restaurant, options|
        restaurant.id.to_s || ""
      end

    expose :lambda_name, as: :name,
      if: lambda { |restaurant, options| options[:detail] || options[:review_list] } do |restaurant, options|
        restaurant.name.to_s || ""
      end
    expose :lambda_city, as: :city,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        restaurant.city.to_s || ""
      end
    expose :lambda_email, as: :email,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        restaurant.email.to_s || ""
      end
    expose :lambda_address, as: :address,
      if: lambda { |restaurant, options| options[:detail] || options[:review_list] } do |restaurant, options|
        restaurant.halal_address.to_s || ""
      end
    expose :lambda_phone, as: :phone,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        restaurant.phone.to_s || ""
      end
    expose :lambda_suggester_name, as: :suggester_name,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        restaurant.suggester_name.to_s || ""
      end
    expose :lambda_suggester_email, as: :suggester_email,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        restaurant.suggester_email.to_s || ""
      end
    expose :lambda_suggester_phone, as: :suggester_phone,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        restaurant.suggester_phone.to_s || ""
      end
    expose :lambda_website, as: :website,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        restaurant.website.to_s || ""
      end

    expose :lambda_is_favourite, as: :is_favourite,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        options[:user].favourite_or_not?(restaurant.id)
      end
    expose :lambda_opening_hours, as: :opening_hours,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        Schedule.restaurant_group_open_hours(restaurant.id)
      end
    expose :lambda_offer, as: :offer,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        restaurant.get_offer_content
      end
    expose :lambda_filters, as: :filters,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        restaurant.filters
      end
    expose :lambda_reviews, as: :reviews,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        page_index = options[:page_index] || 1
        page_size = options[:page_size] || 8
        restaurant.reviews.approved.page(page_index).per(page_size) || []
      end
    expose :lambda_review_count, as: :review_count,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        restaurant.reviews.approved.count
      end
    expose :lambda_latest_review, as: :latest_review,
      if: lambda { |restaurant, options| options[:detail] } do |restaurant, options|
        Review::Entity.represent(restaurant.reviews.approved.last, latest: true)
      end

    # lambda_review_list
    expose :lambda_review_list_image, as: :image,
      if: lambda { |restaurant, options| options[:review_list] } do |restaurant, options|
        restaurant.cover ? restaurant.cover.image.thumb("80x80#").url : ActionController::Base.helpers.asset_path("no_restaurant.png")
      end
    expose :lambda_review_list_country, as: :country,
      if: lambda { |restaurant, options| options[:review_list] } do |restaurant, options|
        restaurant.country
      end

    # lambda_favourite_list
    expose :lambda_favourite_name, as: :name,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.name || ""
      end
    expose :lambda_favourite_image, as: :image,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.cover ? restaurant.cover.image.thumb("80x80#").url : ActionController::Base.helpers.asset_path("no_restaurant.png")
      end
    expose :lambda_favourite_address, as: :address,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.halal_address || ""
      end
    expose :lambda_favourite_country, as: :country,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.country || ""
      end
    expose :lambda_favourite_description, as: :description,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.description || ""
      end
    expose :lambda_favourite_status, as: :status,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.disabled || ""
      end
    expose :lambda_favourite_price, as: :price,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.price.to_s || ""
      end
    expose :lambda_favourite_rating, as: :rating,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.rating_avg.to_s || ""
      end
    expose :lambda_favourite_latest_review, as: :latest_review,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        Review::Entity.represent(restaurant.reviews.approved.last, latest: true)
      end
    expose :lambda_favourite_review_number, as: :review_number,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.reviews.approved.count.to_s || ""
      end
    expose :lambda_favourite_distance, as: :distance,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.distance_from([options[:lat] || 0,options[:long] || 0])
      end
    expose :lambda_favourite_postcode, as: :postcode,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.postcode
      end
    expose :lambda_favourite_website, as: :website,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.website
      end
    expose :lambda_favourite_is_favourite, as: :is_favourite,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        true
      end
    expose :lambda_favourite_lat, as: :lat,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.lat.to_s || ""
      end
    expose :lambda_favourite_lon, as: :long,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.lng.to_s || ""
      end
    expose :lambda_favourite_halal_status, as: :halal_status,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.halal_status || ""
      end

    expose :lambda_favourite_opening_hours, as: :opening_hours,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        Schedule.restaurant_group_open_hours(restaurant.id)
      end
    expose :lambda_favourite_cuisine, as: :cuisine,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.cuisine
      end
    expose :lambda_favourite_restaurant_url, as: :restaurant_url,
      if: lambda { |restaurant, options| options[:favourite_list] } do |restaurant, options|
        restaurant.slug || ""
      end


  end

  # ============================================================================
  # INSTANCE - ACTION
  # ============================================================================
  #

  def self.filter_restaurant filter_id
    case filter_id.to_i
    when 0
      return Restaurant
    when 1
      return Restaurant.joins(:photos)
    when 2
      return Restaurant.joins('left join photos on restaurants.id = photos.restaurant_id')
                       .where('photos.id is NULL')
    end
  end

  def self.have_change_photo_request
    Restaurant.select {|r| r.photos.is_new.count > 0}
  end

  def self.ransackable_attributes auth_object = nil
    super & RANSACKABLE_ATTRIBUTES
  end

  # get 3 restaurant has highest rating avg
  def self.get_restaurant_has_high_rating
    order("rating_avg DESC").limit(3)
  end

  def self.open_now
    dow = Time.now.wday
    now = Time.now.strftime('%H%M').to_i
    where("schedules.day_of_week = ? && schedules.time_open <= ? && schedules.time_closed >= ?", dow, now, now).joins(:schedules)
  end
  # this function to get restaurant by filter time
  def self.open_in_time(filter_time)
    dow, time = Schedule.to_dow_time(filter_time)
    where("schedules.day_of_week = ? && schedules.time_open <= ? && schedules.time_closed >= ?", dow, time, time).joins(:schedules)
  end
  # this function to get restaurant by filter ids
  def self.search_by_ft_ids(ft_ids, text)
    joins("INNER JOIN filters_restaurants AS #{text} ON restaurants.id = #{text}.restaurant_id").where("#{text}.filter_id IN (?)", ft_ids).uniq
  end
  # this function to get restaurant by lat, lng, zoom level
  def self.search_near(lat,lng,zoom_level)
    near([lat,lng], Restaurant::ZOOM_LEVEL[zoom_level])
  end
  # search near with post code
  def self.search_near_post_code(lat,lng,zoom_level=nil)
    near([lat,lng], 5)
  end
  # this function use for search by text keyword
  # this function called in search_location_name function
  def self.search_by_text(query_string, search_text)
    keywords = search_text.split(%r{,\s*|\r\n}).map {|term| "%#{term}%" }
    where(query_string, keywords.first, keywords.first, keywords.first, keywords.first, keywords.first, keywords.first)
  end
  # "filter_search" -> this function use for filter by filter ids, lat, lng
  # this function called in search function
  def self.filter_search( filter_ids=nil, sort_by=nil, lat, lng, zoom_level )
    restaurants = self
    if filter_ids.present?
      filter_ids.uniq!
      if filter_ids.include? OFFER_ID
        restaurants = restaurants.have_offer
      end
      filter_ids_group = Hash.new
      filter_ids.map! {|ft| ft = ft.split(",")}
      filter_ids.each {|ft| filter_ids_group[ft[1]].nil? ? filter_ids_group[ft[1]] = [ft[0]]: filter_ids_group[ft[1]] << ft[0]}

      filter_ids_group.each do |k,v|
        restaurants = restaurants.search_by_ft_ids(v,"ft_#{k}")
      end
    end
    if sort_by == 'distance'
      restaurants = restaurants.search_near(lat,lng,zoom_level)
    else
      restaurants = restaurants.search_near(lat,lng,zoom_level).reorder('') if lat.present?
      restaurants = restaurants.order("#{sort_by}")
    end
    restaurants
  end
  # "search_location_name" -> this function use for search restaurant by location name. Such as address name, or restaurant name.
  # this function called in search funtion
  #
  def self.search_location_name(search_text)
    # restaurant = Restaurant.enabled.group('restaurants.id')
    if search_text.present?
      query_string = "address LIKE ? OR name LIKE ? OR city LIKE ? OR short_address LIKE ? OR district LIKE ? OR postcode LIKE ?"
      restaurant = self.search_by_text(query_string, search_text) if query_string
    end
    restaurant
  end

  # This function is process search when user request from browser
  def self.search_restaurant(location_name, drage, lat, long, zoom_level, filter_time, filter_ids, order_by, page, limit=nil)
    restaurants = Restaurant.enabled

    if location_name.present?
      restaurants = restaurants.search_location_name(location_name)
      # UserMailer.send_keysearch_for_admin(location_name).deliver if restaurants.length == 0
      if restaurants.length == 0
        location = Geocoder.coordinates(location_name + 'UK')
        if location.present?
          lat = location[0]
          long = location[1]
          restaurants =  Restaurant.enabled.search_near_post_code(lat, long, zoom_level).reorder('distance')
        end
      end
      UserMailer.send_keysearch_for_admin(location_name).deliver if restaurants.length == 0
    end
    # search when user drage map
    if lat.present? && long.present? && drage == true
      restaurants = Restaurant.enabled if restaurants.length == 0
      restaurants = restaurants.search_near(lat, long, zoom_level).reorder('distance')
    end
    # filter result
    if filter_ids.present? && restaurants.length > 0
      if filter_ids.present? && filter_ids.first && filter_ids.first.sub(",","").present?
        restaurants = restaurants.filter_search(filter_ids, order_by, lat, long, zoom_level)
      else
        restaurants = restaurants.order("#{order_by}") if order_by != 'distance'
      end
    end
    restaurants = Kaminari.paginate_array(restaurants).page(page).per(limit)
    restaurants
  end
  # this function to get restaurant by name of restaurant
  def self.search_by_name(name)
    restaurants = Restaurant.arel_table
    Restaurant.where(restaurants[:name].matches("%#{name}%")).order("name ASC")
  end
  # this function to define sort result
  def self.order_by_query_string(text)
    case text
    when "rating"
      "restaurants.rating_avg DESC , restaurants.name ASC"
    when "name"
      "restaurants.name ASC, restaurants.id ASC"
    when "price_low"
      "restaurants.price ASC, restaurants.name ASC"
    when "price_high"
      "restaurants.price DESC , restaurants.name ASC"
    when "distance"
      'distance'
    else
      "restaurants.rating_avg DESC, restaurants.name ASC"
    end
  end

  def self.create_with_params params

    if params[:name].blank? && params[:city].blank? && params[:email].blank? && params[:address].blank? && params[:phone].blank?
      return {success: false, message: I18n.t("service_api.errors.missing_required_fields"), error: 333}
    end

    unless (params[:service].present? && params[:quality].present? && params[:value].present? && params[:content].present? && params[:month].present? && params[:year].present?) ||
      (params[:service].blank? && params[:quality].blank? && params[:value].blank? && params[:content].blank? && params[:month].blank? && params[:year].blank?)
      return {success: false, message: I18n.t("service_api.errors.missing_required_fields"), error: 333}
    end

    unless (params[:suggester_name].present? && params[:suggester_email].present? && params[:suggester_phone].present?) ||
      (params[:suggester_name].blank? && params[:suggester_email].blank? && params[:suggester_phone].blank? && params[:website].blank?)
      return {success: false, message: I18n.t("service_api.errors.missing_required_fields"), error: 333}
    end

    @restaurant = new(
      name: params[:name], city: params[:city], email: params[:email],
      address: params[:address], phone: params[:phone]
    )

    if params[:service].present?
      @review = Review.new(
        service: params[:service], quality: params[:quality],
        value: params[:value], content: params[:content]
      )
      @review.visited_date = DateTime.new(params[:year].to_i, params[:month].to_i,15)
    elsif params[:suggester_name].present?
      @restaurant.suggester_name = params[:suggester_name]
      @restaurant.suggester_email = params[:suggester_email]
      @restaurant.suggester_phone = params[:suggester_phone]
      @restaurant.website = params[:website]
    else
      return {success: false, message: I18n.t("service_api.errors.missing_required_fields"), error: 333}
    end

    if @restaurant.save
      if @review.present?
        @review.restaurant_id = @restaurant.user.id
        unless @review.save
          @restaurant.destroy
          return {success: false, message: @review.errors.values.join(", "), error: 403}
        end
      end
      return {success: true, message: I18n.t("service_api.success.add_restaurant"), data: Entity.represent(@restaurant)}
    else
      return {success: false, message: @restaurant.errors.values.join(", "), error: 403}
    end
  end

  def self.actions_with_params params, action_name = "", user = nil
    if params[:restaurant_id].blank?
      return {success: false, message: I18n.t("service_api.errors.missing_required_fields"), error: 333}
    else
      restaurant = find_by_id(params[:restaurant_id])
      if restaurant.nil?
        return {success: false, message: I18n.t("service_api.errors.restaurant_not_found"), error: 1000}
      end
    end

    case action_name
    when "get_detail"
      get_detail_with_params params, restaurant, user
    when "get_menus"
      get_menus_with_params params, restaurant
    when "add_review"
      add_review_with_params params, restaurant
    when "get_list_reviews"
      get_list_reviews_with_params params, restaurant
    else
      return {success: false, message: "Invalid action name", error: 334}
    end
  end

  def self.get_detail_with_params params, restaurant, user
    data = Entity.represent(restaurant, detail: true, page_size: params[:page_size], page_index: params[:page_index], user: user)
    return {success: true, message: I18n.t("service_api.success.get_restaurant_detail"), data: data}
  end

  def self.get_menus_with_params params, restaurant
    if (menus = restaurant.menus).blank?
      return {success: true, message: I18n.t("service_api.success.none_menus"), data: nil}
    else
      return {success: true, message: I18n.t("service_api.success.get_restaurant_menus"), data: Menu::Entity.represent(menus)}
    end
  end

  def self.add_review_with_params params, restaurant
    if params[:service].blank? || params[:quality].blank? || params[:value].blank? || params[:content].blank? || params[:month].blank? || params[:year].blank?
      return {success: false, message: I18n.t("service_api.errors.missing_required_fields"), error: 333}
    end
    review = restaurant.reviews.new(
      service: params[:service], quality: params[:quality],
      value: params[:value], content: params[:content],
      visited_date: DateTime.new(params[:year].to_i, params[:month].to_i,15)
    )
    if review.save
      return {success: true, message: I18n.t("service_api.success.add_review"), data: {}}
    else
      return {success: false, message: review.errors.values.join(", "), error: 403}
    end
  end

  def self.get_list_reviews_with_params params, restaurant
    page_index = params[:page_index] || 1
    page_size = params[:page_size] || 10
    reviews = restaurant.reviews.approved.order(created_at: :desc).page( page_index ).per( page_size )
    if reviews.blank?
      return {success: true, message: I18n.t("service_api.success.none_reviews"), data: nil}
    end
    return {success: true, message: I18n.t("service_api.success.get_list_reviews"), data: Review::Entity.represent(reviews)}
  end

  # ============================================================================
  # CLASS - GET
  # ============================================================================
  def build_new_timesheets
    (1..7).each {|i| self.schedules.build(day_of_week: i)} if self.schedules.blank?
  end

  def build_new_photo
    self.photos.build if self.photos.blank?
  end

  def slug_id_name
    [:name, :id]
  end

  def to_param
    id.to_s
  end

  def restaurant_name
    name
  end

  def display_city
    if district.present?
      "#{district}, #{city}"
    else
      "#{city}"
    end
  end

  def user_name
    user.username_email if user_id
  end

  def should_generate_new_friendly_id?
    new_record?
  end

  def rating_avg
    r = read_attribute(:rating_avg)
    r = r.round(1)
    i = r - r.floor
    case
    when i <= 0.25
      r.floor
    when i >= 0.75
      r.ceil
    else
      r.floor + 0.5
    end
  end

  def service_avg
    r = read_attribute(:service_avg)
    r = r.round(1)
    i = r - r.floor
    case
    when i <= 0.25
      r.floor
    when i >= 0.75
      r.ceil
    else
      r.floor + 0.5
    end
  end

  def quality_avg
    r = read_attribute(:quality_avg)
    r = r.round(1)
    i = r - r.floor
    case
    when i <= 0.25
      r.floor
    when i >= 0.75
      r.ceil
    else
      r.floor + 0.5
    end
  end

  def value_avg
    r = read_attribute(:value_avg)
    r = r.round(1)
    i = r - r.floor
    case
    when i <= 0.25
      r.floor
    when i >= 0.75
      r.ceil
    else
      r.floor + 0.5
    end
  end


  def disable_toggle disabled=nil
    if disabled == nil
      self.disabled = (self.disabled == true || self.disabled == nil )? false : true
    else
      self.disabled = !disabled
    end
    if self.save!
      true
    else
      false
    end
  end

  def cover
    cover = Photo.where("restaurant_id = #{id} and cover = true and status = 1").first
    cover = photos.approved.first unless cover

    cover
  end

  def cover_url
    cover = Photo.where("restaurant_id = #{id} and cover = true and status = 1").first
    cover = photos.approved.first unless cover

    if cover
      cover.url
    else
      ActionController::Base.helpers.asset_path('restaurant_default.png')
    end
  end

  # get review better in reviews for restaurant
  def get_featured_review
    self.reviews.order('rating DESC').first
  end

  #

  def everage_ratings
    avg_service = 0
    avg_quality = 0
    avg_value = 0
    all_reviews = self.reviews
    count = !all_reviews.blank? ? all_reviews.count.to_f : 1.0
    all_reviews.each do |r|
      avg_quality += r.quality
      avg_service += r.service
      avg_value += r.value
    end

    ret_service = avg_service/count
    ret_quality = avg_quality/count
    ret_value = avg_value/count

    [ret_service, ret_quality, ret_value, (ret_quality + ret_value + ret_service)/3]
  end

  def cuisine
    filters.cuisine.map {|c| c.name}
  end

  def three_cuisines
    cuisines = self.filters.cuisine.limit(3) if self.filters
  end

  def get_price_restaurant
    self.filters.price.first.name if self.filters && self.filters.price.length > 0
  end

  def price_value
    price_filter = filters.where(:id => FILTER_PRICE_IDS).last
    price_filter.blank? ? '' : price_filter.description
  end

  def halal_address
    halal_address = [short_address, district, postcode].compact
    halal_address.delete("")
    halal_address.join(', ')
  end

  def email_to_contact
    if email.present?
      email
    elsif user
      user.email
    end
  end

  def get_offer_content
    if self.offers && self.offers.approved.length > 0
      time_valilable = self.offers.approved.last.get_time_valilable
      "#{self.offers.approved.last.offer_content} <br> <div class='lowercase'>#{time_valilable}</div>".html_safe()
    end
  end

  def get_offer_image
    if self.offers && self.offers.approved.length > 0
      self.offers.approved.last.image.url if self.offers.approved.last && self.offers.approved.last.image
    else
      ""
    end
  end

  def get_offer_publish_date
    if self.offers && self.offers.approved.length > 0
      time_publish = self.offers.approved.last.get_time_publish
      "From #{time_publish}"
    end
  end

  def random_gem_hunter
    gem_hunters = self.reviews.joins('INNER JOIN users ON reviews.user_id = users.id').approved.where("users.gem_hunter IS true")
    offset = rand(gem_hunters.count) - 1
    if offset < 1
      gem_hunters.first
    else
      gem_hunters.offset(offset).first
    end
  end

  def normal_reviews
    self.reviews.joins('INNER JOIN users ON reviews.user_id = users.id').approved.where("users.gem_hunter IS false")
  end

  # ============================================================================
  # CLASS - CHECK
  # ============================================================================

  def check_status?
    if self.halal_status ==""
      return false
    else
      return true
    end
  end

  def is_staff_confirmation?
    if self.filters && self.filters.halal_status && self.filters.halal_status.where(:code=>"staff_confirmation").first
      true
    else
      false
    end
  end

  def is_sign_in_windown?
    if self.filters && self.filters.halal_status && self.filters.halal_status.where(:code=>"sign_in_window").first
      true
    else
      false
    end
  end

  def is_certificate_available?
    if self.filters && self.filters.halal_status && self.filters.halal_status.where(:code=>"certificate").first
      true
    else
      false
    end
  end

  def is_wifi?
    if self.filters && self.filters.features && self.filters.features.where(:code =>"wifi_available").first
      true
    else
      false
    end
  end

  def is_wheel_chair_access?
    if self.filters && self.filters.features && self.filters.features.where(:code => "wheelchair_accessible").first
      true
    else
      false
    end
  end

  def is_organic?
    if self.filters.where(code: 'organic').first
      true
    else
      false
    end
  end

  def is_no_alcohol?
    if  self.filters.where(:code=> "alcohol_not_allowed").first
      true
    else
      false
    end
  end

  def is_alcohol?
    if  self.filters.where(:code=> "alcohol_served").first
      true
    else
      false
    end
  end

  def is_byob?
    if self.filters.alcohol && self.filters.alcohol.where(:code=> "bring_your_own").first
      true
    else
      false
    end
  end

  def is_shisha?
    if self.filters && self.filters.where(:code=> "shisha_allowed").first
      true
    else
      false
    end
  end

  def is_deliver?
    if self.filters && self.filters.features && self.filters.features.where(:code=> "delivery_available").first
      true
    else
      false
    end
  end

  def have_social_link?
    if self.facebook_link.present?  || self.twitter_link.present? || self.pinterest_link.present? || self.instagram_link.present?
      true
    else
      false
    end
  end

  # ============================================================================
  # CLASS - ACTION
  # ============================================================================
  def update_rating
    all_reviews = Review.approved.where("restaurant_id = ?", self.id)
    count = !all_reviews.blank? ? all_reviews.count.to_f : 1.0
    avg_quality = 0
    avg_service = 0
    avg_value = 0
    all_reviews.each do |r|
      avg_quality += r.quality
      avg_service += r.service
      avg_value += r.value
    end
    self.service_avg = avg_service/count
    self.quality_avg = avg_quality/count
    self.value_avg = avg_value/count
    self.rating_avg = (service_avg + quality_avg + value_avg) / 3
    self.save
  end

  def update_filter_type_ids
    ft_ids = []
    pv = 0
    filters.each do |ft|
      ft_ids << ft.filter_type_id
      # pv = ft.description.size if ft.filter_type_id == FILTER_TYPE_PRICE_ID
    end
    ft_ids.uniq!
    # self.price = pv
    self.filter_type_ids = ft_ids
  end

  # get time open and close of restaurant in weeks, show on view
  # ex: Every Day : 6am-3pm, 5pm-11pm
  # ex: Weekdays : 6am-3pm, 5pm-11pm / Weekends : 6am-3pm, 5pm-7pm
  # ex: Mon to Wed : 6am-3pm, 5pm-11pm / Fri : 6am-3pm, 5pm-11pm
  #     Thu : 6am-3pm, 6pm-11pm / Weekends : 6am-3pm, 5pm-7pm
  def opening_time_daily
    # store id schedules for check schedule is included to result
    viewed = []
    # text time schedule of restaurants built
    result = ""
    # count is 1 | 2, detect if = 2 to add " / " before add time str to result
    count = 1
    start = true

    # check schedule is existed and available
    if self.schedules && self.schedules.is_set_daily.length > 0
      # loop of all daily schedules order by day of with, 1..7 to get the sames time
      self.schedules.is_set_daily.order(day_of_week: :asc).each_with_index do |schedule, index|
        # check schedule is not included
        if !viewed.include?(schedule.id)
          # get evening schedule corresponding to daily schedule on day-of-week
          evening_schedule = self.schedules.is_set_evening.evening_schedule_by_dow(schedule.day_of_week);

          # only daily schedule in that day
          if evening_schedule.nil?
            # get all schedules match with opentime and closed time
            sames = schedules.select{|s|
              schedule.time_open == s.time_open &&
              schedule.time_closed == s.time_closed
            }
          else # have both daily and evening
            # get all schedules match with opentime and closed time of both daily and evening
            sames = schedules.select{|s|
              schedule.time_open == s.time_open &&
              schedule.time_closed == s.time_closed &&
              evening_schedule.time_open == self.schedules.is_set_evening.evening_schedule_by_dow(s.day_of_week).time_open &&
              evening_schedule.time_closed == self.schedules.is_set_evening.evening_schedule_by_dow(s.day_of_week).time_closed
            }
          end
          # mark schedules is filter same
          sames.each do |s|
            viewed.push(s.id)
          end
          # sames schedules not null
          if sames.count > 0
            arr = str_schedules_same_time(sames, count, start)
            result << arr[0]
            sames = []
            count = arr[1]
            start = (count == 1 ? true : false)
          end
        end
      end # end loop schedules
    end
    result = "<div class='clearfix'></div>#{result}<div class='clearfix'></div>"
  end

  # build string same time schedule
  def str_schedules_same_time(arr_schedules, count, start)
    length = arr_schedules.count
    result = ""
    # store id schedules, that pushed to result
    ids = []
    (0...length).each do |index|
      # current_schedule
      schedule = arr_schedules[index]
      ids.push(schedule.id)
      # last schedule, if#1
      if index == length-1
        result << " / " if count > 1 #!  count >= 1 && !start

        # first===last, only 1 schedule in array
        if ids.count == 1
          result << "#{schedule.day_formated} : #{schedule.time_open_formated}-#{schedule.time_closed_formated}"
          evening_schedule = self.schedules.is_set_evening.evening_schedule_by_dow(schedule.day_of_week);

          if evening_schedule.present?
            evening_time = evening_schedule.evening_time_formated
            result << ", #{evening_time}" unless evening_time.blank?
          end
          count += 1

        else # last schedule and array schedules > 1
          first_schedule = Schedule.find_by_id(ids[0])
          last_schedule = Schedule.find_by_id(ids[-1])
          # alldays (all 7 schedules are same)
          if ids.count == 7
            result << "Every Day"
          elsif ids.count == 5 &&
            first_schedule.day_formated == 'Mon' &&
            last_schedule.day_formated == 'Fri'
            result << "Weekdays"
          elsif ids.count == 2 &&
            first_schedule.day_formated == 'Sat' &&
            last_schedule.day_formated == 'Sun'
            result << "Weekends"
          else
            result << "#{first_schedule.day_formated} to #{last_schedule.day_formated}"
          end
          result << " : #{first_schedule.time_open_formated}-#{first_schedule.time_closed_formated}"
          evening_schedule = self.schedules.is_set_evening.evening_schedule_by_dow(first_schedule.day_of_week);

          if !evening_schedule.nil?
            evening_time = evening_schedule.evening_time_formated
            result << ", #{evening_time}" unless evening_time.blank?
          end
          count += 1
        end
        #! start = false
        #! ids = [] # clear array when
      else # not last schedule
        first_schedule = Schedule.find_by_id(schedules[0])
        last_schedule = Schedule.find_by_id(schedules[-1])
        # schedules not is weekend
        unless (arr_schedules.count == 2 &&
                  first_schedule.day_formated == 'Sat' &&
                  last_schedule.day_formated == 'Sun')
          # schedule next in array not the next day
          if arr_schedules[index+1].day_of_week != schedule.day_of_week+1
            # add '/' before string when it not a start string
            result << " / " if count > 1
            # first child of row result
            if ids.count == 1
              result << "#{schedule.day_formated} : #{schedule.time_open_formated}-#{schedule.time_closed_formated}"
              evening_schedule = self.schedules.is_set_evening.evening_schedule_by_dow(schedule.day_of_week);
              if evening_schedule.present?
                evening_time = evening_schedule.evening_time_formated
                result << ", #{evening_time}" if evening_time.present?
              end
            else # not first child
              first_schedule = Schedule.find_by_id(ids[0])
              last_schedule = Schedule.find_by_id(ids[-1])
              result << "#{first_schedule.day_formated} to #{last_schedule.day_formated}"
              result << " : #{first_schedule.time_open_formated}-#{first_schedule.time_closed_formated}"
              evening_schedule = self.schedules.is_set_evening.evening_schedule_by_dow(first_schedule.day_of_week);
              if evening_schedule.present?
                evening_time = evening_schedule.evening_time_formated
                result << ", #{evening_time}" if evening_time.present?
              end
            end
            count += 1
            start = false
            ids = [] # clear ids when next schedule is not next day
          end # => else only push to ids
        end
      end # end if#1

      # add break
      if count > 2
        result << "</br>"
        count = 1
        start = true
      end
    end # end loop
    [result, count]
  end

end

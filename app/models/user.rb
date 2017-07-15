class User < ActiveRecord::Base
  include Grape::Entity::DSL
  # ============================================================================
  # BEFORE ACTION
  # ============================================================================
  #ajaxful_rater
  #after_create :set_status_for_signup_user
  #after_update :check_and_update_status
  if !Rails.env.test?
    after_create :add_to_mailchimp
  end
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # ============================================================================
  # ATTRIBUTES
  # ============================================================================
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable, :timeoutable, :omniauthable,
         :mailchimp
  # Setup accessible (or protected) attributes for your model
  image_accessor  :avatar
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :address, :avatar, :email, :first_name, :im, :last_name, :middle_name,
                  :phone, :status, :username,
                  :admin_role, :provider,:uid, :name, :is_subscribed,
                  :join_mailing_list,:retained_avatar,:remove_avatar,:avatar_fb_url, :postcode,
                  :device_token, :device_type, :fb_access_token,
                  :gem_hunter, :gem_hunter_wordpress_url

  # ============================================================================
  # ASSOCIATION
  # ============================================================================
  has_many :restaurants
  has_many :photos
  has_many :reviews
  has_many :admin_photos #, :conditions=>"admin_role is true"
  has_many :subscriptions
  has_many :favourites
  has_many :favourite_restaurants, through: :favourites, source: :restaurant

  has_many :ratings
  has_many :review_comments

  # ============================================================================
  # ENUM
  # ============================================================================
  STATUS = %w[unverified verified closed]
  # Setup searchable attributes for user model
  RANSACKABLE_ATTRIBUTES = ["email", "username", "address", "phone", "status", "created_at"]
  DEVICE_TYPE = { android: 0, ios: 1}
  # ============================================================================
  # VALIDATIONS
  # ============================================================================
  validates :username, presence: true
  validates_uniqueness_of :username
  validates_confirmation_of :password, :on=>:update, :message =>I18n.t('signup.match_pass')
  #validates_uniqueness_of :email, :message=>I18n.t('signup.email_exist')
  #validates_length_of :password, :within => 6..20, :too_long => I18n.t('signup.password_long'), :too_short => I18n.t('signup.password_short')

  # ============================================================================
  # ENTITY
  # ============================================================================
  entity do
    expose :get_id                   , as: :id                   , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :get_email                , as: :email                , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :get_phone                , as: :phone                , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :get_username                , as: :username          , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :get_first_name           , as: :first_name           , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :get_last_name            , as: :last_name            , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :get_avatar_url           , as: :avatar_url           , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :get_authentication_token , as: :authentication_token , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :get_status               , as: :user_status          , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :full_name                 , as: :name                , :if  => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :is_gem_hunter, as: :gem_hunter                       , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :is_restaurant_owner_role, as: :halalgems_owner       , :if => lambda { |user, options| options[:type] == :detail || options[:type] == nil }
    expose :get_favourites, as: :favourites                      , :if => { type: :detail}
    expose :get_reviews, as: :reviews                            , :if => { type: :detail}
  end
  # ============================================================================
  # CLASS - ACTION
  # ============================================================================

  def get_list_favourites_restaurant_with_params params
    page_index = params[:page_index] || 1
    page_size = params[:page_size] || 30
    restaurants = favourite_restaurants.page( page_index ).per( page_size )
    if restaurants.blank?
      return {success: true, message: I18n.t("service_api.success.none_favourites"), data: nil}
    end
    return {
      success: true, message: I18n.t("service_api.success.get_list_favourites"),
      data: Restaurant::Entity.represent(
          restaurants, favourite_list: true, user: self,
          lat: params[:lat],
          long: params[:long]
        )
    }
  end

  def add_to_favourite_list_with_params params
    if params[:restaurant_id].blank?
      return {success: false, message: I18n.t("service_api.errors.missing_required_fields"), error: 333}
    else
      restaurant = Restaurant.find_by_id(params[:restaurant_id])
      if restaurant.nil?
        return {success: false, message: I18n.t("service_api.errors.restaurant_not_found"), error: 1000}
      end
    end

    if check_favourited restaurant.id
      return {success: false, message: I18n.t("service_api.errors.restaurant_was_already_added_to_favourite_list"), error: 1004}
    else
      favourite = favourites.new(restaurant_id: restaurant.id)
      if favourite.save
          return {success: true, message: I18n.t("service_api.success.add_to_favourite_list"), data: {}}
      else
          return {success: false, message: restaurant.errors.values.join(", "), error: 403}
      end
    end
  end

  def remove_from_favourite_list_with_params params
    if params[:restaurant_id].blank?
      return {success: false, message: I18n.t("service_api.errors.missing_required_fields"), error: 333}
    else
      restaurant = Restaurant.find_by_id(params[:restaurant_id])
      if restaurant.nil?
        return {success: false, message: I18n.t("service_api.errors.restaurant_not_found"), error: 1000}
      end
    end

    if check_favourited restaurant.id
      favourites.find_by_restaurant_id(restaurant.id).destroy
      return {success: true, message: I18n.t("service_api.success.remove_from_favourite_list"), data: {}}
    else
      return {success: false, message: I18n.t("service_api.errors.restaurant_was_not_favourited_yet"), error: 1005}
    end
  end

  def check_favourited restaurant_id
    favourites.find_by_restaurant_id(restaurant_id).present?
  end

  def get_id
    id
  end

  def get_authentication_token
    authentication_token
  end

  def get_email
    email
  end

  def get_phone
    phone
  end

  def get_username
    username
  end

  def get_first_name
    first_name
  end

  def get_last_name
    last_name
  end

  def favourite_or_not?(restaurant_id)
    !Favourite.where("user_id = ? && restaurant_id = ?",self.id,restaurant_id).blank?
  end

  def get_status
    status
  end

  def is_gem_hunter
    gem_hunter
  end

  def is_restaurant_owner_role
    restaurant_owner_role
  end

  def get_avatar_url(size=nil)
    if self.avatar.nil? || self.avatar.image.nil?
      avatar_fb_url
    else
      size.blank? ? self.avatar.image_url : self.avatar.image.thumb(size).url
    end
  end

  def get_favourites
    favourites = Restaurant.my_favourite(self.id)
    count = favourites.length
    data = favourites.page(1).per(10)
    return output= {count: count, data: data}
  end

  def get_reviews
    reviews = Review.where(:user_id=> self.id).order("created_at DESC")
    count = reviews.length
    data = reviews.page(1).per(10)
    return output= {count: count, data: data}
  end

  def is_verified?
    status == STATUS[1]
  end

  def is_account_active?
    status != STATUS[2]
  end
  # Check if the current object is valid for authentication.
  def active_for_authentication?
    super && is_account_active?
  end

  def is_admin_role?
    self.admin_role == true
  end

  def is_no_active_subscription?
    self.is_restaurant_owner_role? && self.subscriptions.active.length == 0
  end

  def is_restaurant_owner_role?
    restaurant_owner_role && restaurants.length > 0
  end

  def is_profession_user?
    self.subscriptions.subs_success.length > 0
  end

  def is_profession_user_avail?
    if self.is_admin_role?
      true
    elsif self.subscriptions.active.length > 0
      sub = self.subscriptions.active.last
      sub.expire_time > Time.now
    else
      false
    end
  end

  def add_to_mailchimp
    self.add_to_mailchimp_list(Devise.mailing_list_name)
  end

  def set_restaurant_owner_role
    self.update_attribute('restaurant_owner_role',true) if !restaurant_owner_role
  end

  def username_email
    "#{username} (#{email})"
  end

  def full_name
    if username
      username
    else
      "#{first_name} #{middle_name} #{last_name}"
    end
  end

  def update_gem_hunter(status, profile_url)
    update_column(:gem_hunter, status)
    update_column(:gem_hunter_wordpress_url, profile_url)
    reload
  end

  def change_status(status)
    status.downcase!
    if User::STATUS.include?(status)
      self.status = status
      if status == User::STATUS[0]
        self.confirmed_at = nil
        self.send_confirmation_instructions
      end
      self.save
    else
      false
    end
  end


  # ============================================================================
  # INSTANCE - ACTION
  # ============================================================================

  def self.ransackable_attributes auth_object = nil
    super & RANSACKABLE_ATTRIBUTES
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user =  User.find_by_email(auth.info.email)
      unless user
        user = User.new( username: auth.info.nickname,
                 provider: auth.provider,
                 uid: auth.uid,
                 email: auth.info.email,
                 status: 'verified'
               )
      end
      user.provider = auth.provider
      user.uid = auth.uid
      user.save  validate: false
    end
    user
  end

  def self.check_fb_login_for_api(fb_access_token)
    begin
      m = FbGraph::User.me(fb_access_token).fetch
    rescue Exception => e
      return  nil
    end
    fb_picture = m.picture
    unless fb_picture.include?("width") && fb_picture.include?("height")
      fb_picture = m.picture.to_s << "?width=300&height=300"
    end
    if (user = User.where(uid: m.identifier).first) || (m.email && user = User.where(email: m.email).first)
      new_attributes = {uid: m.identifier, fb_access_token: fb_access_token,
       avatar_fb_url: fb_picture, status: STATUS[1]}
      user.update_attributes new_attributes
      return user
    else
      user = User.new(email: m.email, last_name: m.last_name, first_name: m.first_name, name: m.name,
        username: m.username, fb_access_token: fb_access_token, uid: m.identifier, avatar_fb_url: fb_picture,
        provider: 'facebook', status: STATUS[1] )
      user.save validate: false
      return user
    end
  end

  #private
  def self.set_status_for_signup_user
    self.status = "unverified"
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def ensure_authentication_token!
    self.authentication_token = generate_authentication_token
    self.save validate: false
  end

  def update_device_info( input_device_token, input_device_type)
    if input_device_token.present?
      User.where(device_token: input_device_token).update_all(:device_token => nil)
      self.update_attributes(device_token: input_device_token, device_type: input_device_type)
      self.save(validate: false)
    end
  end
end

# Override to send confirmation to old email
module Devise
  module Models
    module Confirmable
      def headers_for(action)
        headers = super
        headers
      end
      module ClassMethods
        def find_by_unconfirmed_email_with_errors(attributes = {})
            unconfirmed_required_attributes = confirmation_keys.map { |k| k == :email ? :email : k }
            unconfirmed_attributes = attributes.symbolize_keys
            unconfirmed_attributes[:unconfirmed_email] = unconfirmed_attributes.delete(:email)
            find_or_initialize_with_errors(unconfirmed_required_attributes, unconfirmed_attributes, :not_found)
          end
      end
    end
  end
end

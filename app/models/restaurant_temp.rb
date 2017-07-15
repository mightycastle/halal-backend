class RestaurantTemp < ActiveRecord::Base
  include FriendlyId

  # ============================================================================
  # CLASS - ASSOCIATIONS
  # ============================================================================    
  belongs_to :user
  has_many :schedules
  has_many :photos
  has_and_belongs_to_many :filters

  # ============================================================================
  # ATTRIBUTES
  # ============================================================================  
  friendly_id :name, :use => :history
  accepts_nested_attributes_for :schedules
  accepts_nested_attributes_for :photos

  #image_accessor :menu
  attr_accessor :user_name
  attr_accessible :address, :deliverable, :description, :disabled, :email, 
                  :name, :phone, :shisha_allow, :user_id, :lat, :lng, :district,
                  :city, :postcode, :country, :direction, :filter_ids, :price, 
                   :filter_type_ids, :schedules_attributes, :contact_note, :slug,
                  :suggester_name, :is_owner, :website, :halal_status, :short_address, :user_name,
                  :special_deal, :reviews_attributes, :facebook_link, :twitter_link, :pinterest_link, :restaurant_id,
                  :photos, :suggester_email, :suggester_phone, :instagram_link
  # ============================================================================
  # CLASS - ASSOCIATIONS
  # ============================================================================    
  belongs_to :user
  has_many :schedules, dependent: :destroy
  has_many :photos
  has_and_belongs_to_many :filters




#  scope :enabled, where(:disabled => false)


  # ============================================================================
  # CLASS - GET
  # ============================================================================  
  def user_name
    user.username_email if user_id
  end
end

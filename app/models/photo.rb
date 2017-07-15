class Photo < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include ApplicationHelper

  # ============================================================================
  # BEFORE ACTION
  # ============================================================================  
  # before_save :is_first_upload?
  after_save :set_index_restaurant 


  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================  
  belongs_to :restaurant
  belongs_to :restaurant_temp
  belongs_to :user

  # ============================================================================
  # CLASS - ATTRIBUTES
  # ============================================================================  
  attr_accessible :cover, :restaurant_id, :restaurant_temp_id,:text_title, :text_content, :text_hyperlink, :user_id, :image_uid, :image_name, :image, :status
  
  image_accessor :image
  
  # ============================================================================
  # CLASS - VALIDATES
  # ============================================================================
  validates :image, :presence => true 
  validates_property :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif, :JPEG, :JPG, :PNG, :GIF]

  # ============================================================================
  # ENUM
  # ============================================================================
  STATUS = {is_new: 0, approved: 1, rejected: 2}

  # ============================================================================
  # CLASS - SCOPE
  # ============================================================================
  scope :is_new,   where(status: STATUS[:is_new]).order("restaurant_id ASC, created_at DESC")
  scope :approved, where(status: STATUS[:approved]).order("restaurant_id ASC, created_at DESC")
  scope :rejected, where(status: STATUS[:rejected]).order("restaurant_id ASC, created_at DESC")


  # ============================================================================
  # CLASS - ACTION
  # ============================================================================
  def is_first_upload?
    if Photo.find_by_restaurant_id(restaurant_id).blank?
      self.cover = true
    end
  end
  
  def set_index_restaurant
    restaurant  = self.restaurant
    status = (self.status == 0)? true : false
    restaurant.update_attribute('request_approve_photo', status)
  end

  def to_cover
    if self.status = 1
      Photo.update_all "cover = false", "restaurant_id = #{self.restaurant_id} and cover = true"
      self.cover = true 
      self.save
    else
      false
    end
  end
  
  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "id" => id,
      "name" => read_attribute(:image_name),
      "size" => image.size,
      "url" => image.url,
      "is_cover" => cover,
      "thumbnail_url" => full_url(image.thumb('80x80#').url),
      "delete_url" => full_url(photo_path(:id => id)),
      "delete_type" => "DELETE",
      "modified_date" =>created_at.strftime("%Y-%m-%d"),
      "status" => status
    }
  end


end



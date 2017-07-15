class AdminPhoto < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include ApplicationHelper

  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================
  belongs_to :user


  # ============================================================================
  # ATTRIBUTES
  # ============================================================================
  attr_accessible :cover, :image_name, :image_uid, :user_id, :image, :image_type, :text_content, :text_title, :text_hyperlink

  image_accessor :image
  

  # ============================================================================
  # Validates
  # ============================================================================
  validates :image, :presence => true 
  validates_property :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif, :JPEG, :JPG, :PNG, :GIF]

  # ============================================================================
  # CLASS - ACTION
  # ============================================================================
  def img_type
    image_type ? "Home Page" : "Background"
  end

  def to_jq_upload
    {
      "id" => id,
      "name" => read_attribute(:image_name),
      "size" => image.size,
      "url" => image.url,
      "thumbnail_url" => full_url(image.thumb('80x80#').url),
      "delete_url" => full_url(admin_photo_path(:id => id)),
      "delete_type" => "DELETE",
      "modified_date" =>created_at.strftime("%Y-%m-%d"),
      "img_type" => img_type,
      "change_image_type_url" => full_url(change_image_type_path(:id => id)),
      "text_title" => text_title,
      "text_content" => text_content,
      "text_hyperlink" => text_hyperlink
    }
  end

  # ============================================================================
  # INSTANCE - METHODS
  # ============================================================================

  def self.ramdom_photo
    self.where(image_type: true).order("RAND()").limit(1).first
  end

end

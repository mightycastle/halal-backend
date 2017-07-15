class CollectionImage < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  include Grape::Entity::DSL

  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================  
  belongs_to :collection

  # ============================================================================
  # CLASS - ATTRIBUTES
  # ============================================================================  
  attr_accessible :collection_id, :image, :image_uid, :image_name, :text_content, :text_hyperlink, :text_title

  image_accessor :image
  
  # ============================================================================
  # CLASS - VALIDATES
  # ============================================================================
  # validates :image, :presence => true 
  validates_property :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif, :JPEG, :JPG, :PNG, :GIF]

  # ============================================================================
  # CLASS - ACTION
  # ============================================================================

  def set_index_collection
    collection  = self.collection
  end

  # ============================================================================
  # ENTITY
  # ============================================================================
  
  entity do
    expose :lambda_name, as: :name,
      if: lambda { |image, options| true } do |image, options|
        image.name.to_s || ""
      end 
    expose :lambda_url, as: :url,
      if: lambda { |image, options| true } do |image, options|
        image.image.url || ""
      end 
  end

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      'id' => id,
      'name' => read_attribute(:image_name),
      'size' => image.size,
      'url' => image.url,
      'thumbnail_url' => full_url(image.thumb('160x160#').url),
      'delete_url' => full_url(collection_image_path(:id => id)),
      'delete_type' => 'DELETE',
      'modified_date' =>created_at.strftime('%Y-%m-%d'),
    }
  end

end



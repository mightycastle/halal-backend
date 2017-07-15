class Collection < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include ApplicationHelper

  # ============================================================================
  # ASSOCIATION
  # ============================================================================
  # has_many    :collection_restaurants, dependent: :destroy
  has_one     :collection_image, dependent: :destroy
  has_and_belongs_to_many :restaurants, :join_table => "collection_restaurants"

  # ============================================================================
  # ATTRIBUTES
  # ============================================================================
  attr_accessible :id, :name, :description, :image_url, :collection_images, :disabled

  # ============================================================================
  # VALIDATE
  # ============================================================================
  validates :name, :presence => true
  validates :description, :presence => true
  # validates :collection_image, :presence => true

  # ============================================================================
  # INSTANCE - ACTION
  # ============================================================================
  def update_image_url
    if id
      collection_image = CollectionImage.where("collection_id = #{id}").first
      if collection_image && collection_image.image.present?
        self.image_url = collection_image.image.thumb("160x160#").url
        self.save
        return
      end
    end
    self.image_url = ActionController::Base.helpers.asset_path('collection_image_default.png')
    self.save
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
end



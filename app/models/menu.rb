class Menu < ActiveRecord::Base
  include Grape::Entity::DSL
  include Rails.application.routes.url_helpers
  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================
  belongs_to :restaurant
  belongs_to :user

  # ============================================================================
  # ATTRIBUTES
  # ============================================================================
  attr_accessible :menu_name, :menu_uid, :restaurant_id, :user_id, :menu, :name
  image_accessor :menu
  validates_property :format, :of => :menu, :in => [:pdf, :PDF, :png, :PNG, :jpg, :JPG]

  # ============================================================================
  # ENTITY
  # ============================================================================
  
  entity do
    expose :lambda_name, as: :name,
      if: lambda { |menu, options| true } do |menu, options|
        menu.name.to_s || ""
      end 
    expose :lambda_url, as: :url,
      if: lambda { |menu, options| true } do |menu, options|
        menu.menu.url || ""
      end 
  end

  # ============================================================================
  # CLASS - ACTION
  # ============================================================================
  def to_jq_upload
    {
      "id" => id,
      "name" => read_attribute(:name),
      "size" => menu.size,
      "url" => menu.url,
      "thumbnail_url" => menu.thumb('80x80#').url,
      "delete_url" => menu_path(:id => id),
      "delete_type" => "DELETE",
      "modified_date" =>created_at.strftime("%Y-%m-%d")
    }
  end

  def file_name
    name || menu_name
  end
end

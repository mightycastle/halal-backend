class Filter < ActiveRecord::Base
  include Grape::Entity::DSL
  # ============================================================================
  # RANSACKABLE_ATTRIBUTES
  # ============================================================================
  attr_accessible :code, :description, :name, :value, :filter_type_id

  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================
  belongs_to :filter_type
  has_and_belongs_to_many :restaurants
  has_and_belongs_to_many :restaurant_temps
  

  # ============================================================================
  # ENUMS
  # ============================================================================
  RANSACKABLE_ATTRIBUTES = ['name', 'filter_type_name']
  GROUP = %w[cuisine delivery open_hour alcohol shisha price facilities organic halalgems_status]
  # ============================================================================
  #   
  # ============================================================================
  validates :name, presence: true, :uniqueness => { :scope => :filter_type_id }
  

  # ============================================================================
  #   
  # ============================================================================
  # scope :cuisine,          joins(:filter_type).where('filter_types.code = ?', 'cuisine')
  # scope :open_hour,        joins(:filter_type).where('filter_types.code = ?', 'open_hour')
  # scope :alcohol,          joins(:filter_type).where('filter_types.code = ?', 'alcohol')
  # scope :shisha,           joins(:filter_type).where('filter_types.code = ?', 'shisha')
  # scope :price,            joins(:filter_type).where('filter_types.code = ?', 'price')
  # scope :features,         joins(:filter_type).where('filter_types.code = ?', 'features')
  # scope :organic,          joins(:filter_type).where('filter_types.code = ?', 'organic')
  # scope :halal_status,     joins(:filter_type).where('filter_types.code = ?', 'hal_status')
  # scope :offer,            joins(:filter_type).where('filters.code = ? AND filter_types.code = ?', 'offer', 'features')

  scope :cuisine,          where('code = ?', 'cuisine')
  scope :open_hour,        where('code = ?', 'open_hour')
  scope :alcohol,          where('code = ? OR code =? OR code=?', 'alcohol_served', 'bring_your_own', 'alcohol_not_allowed')
  scope :shisha,           where('code = ? OR code=?', 'shisha_allowed', 'shisha_not_allowed')
  scope :price,            where('code = ?', 'price')
  scope :features,         joins(:filter_type).where('filter_types.code = ?', 'features')
  scope :organic,          where('code = ?', 'organic')
  scope :halal_status,     joins(:filter_type).where('filter_types.code = ?', 'hal_status')
  scope :offer,            where('code = ?', 'offer')
  scope :active,            where('status = ?', true)
  scope :where_not_offer , where('code != ?', 'offer')

  # before action

  before_create :set_code

  # ============================================================================
  # ENTITY
  # ============================================================================

  entity do
    expose :lambda_id, as: :id,
      if: lambda { |object, options| true } do |object, options|
        object.id.to_s || ""
      end 
    expose :lambda_code, as: :code,
      if: lambda { |object, options| true } do |object, options|
        object.code || ""
      end 
    expose :lambda_name, as: :name,
      if: lambda { |object, options| true } do |object, options|
        object.name || ""
      end 
    expose :lambda_description, as: :description,
      if: lambda { |object, options| true } do |object, options|
        object.description || ""
      end 
  end

  # ============================================================================
  # INSTANCE - ACTION
  # ============================================================================
  def self.ransackable_attributes auth_object = nil
    super & RANSACKABLE_ATTRIBUTES
  end
  
  def self.get_filter_type_ids(ids)
    if ids.present?
      ft_ids = ids.map {|id| Filter.find(id).filter_type_id }
      ft_ids.uniq
    end
  end


  def self.sort_alphabet
    order 'name ASC'
  end

  def self.sort_index_order
    order 'index_order ASC'
  end

  def self.sort_index_order_and_name
    order 'index_order ASC, name ASC'
  end

  def set_code
    if self.filter_type_id == FilterType.find_by_code("cuisine").id
      self.code = 'cuisine'
    elsif self.filter_type_id == FilterType.find_by_code("price").id
      self.code = 'price'
    else
      self.code = self.name.parameterize.gsub("-", "_")
    end
  end
end
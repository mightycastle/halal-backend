class FilterType < ActiveRecord::Base
  # ============================================================================
  # ATTRIBUTES
  # ============================================================================
  attr_accessible :name, :code, :index_order

  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================
  has_many :filters
  has_and_belongs_to_many :restaurants
  
  # ============================================================================
  # ENUMS
  # ============================================================================  
  # Setup searchable attributes for user model 
  RANSACKABLE_ATTRIBUTES = ["name"]

  # ============================================================================
  # SCOPE
  # ============================================================================  
  scope :open_hour, where('code = ?', 'open_hour')
  # scope :offer,     where('code = ?', 'offer')
  scope :offer,     where('code = ?', 'features')

  # ============================================================================
  # INSTANCE ACTION
  # ============================================================================  
  def self.ransackable_attributes auth_object = nil
    super & RANSACKABLE_ATTRIBUTES
  end

  def self.all_order_by_index
    order('index_order ASC ')
  end
end

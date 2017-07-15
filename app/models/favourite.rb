class Favourite < ActiveRecord::Base
  # ============================================================================
  # ATTRIBUTES
  # ============================================================================
  attr_accessible :restaurant_id, :user_id

  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================
  belongs_to :user
  belongs_to :restaurant
  

  # ============================================================================
  # VALIDATIONS
  # ============================================================================

  validates :user_id, :presence => true
  validates :restaurant_id, :presence => true

  validates :user_id, :uniqueness => { :scope => :restaurant_id,
    :message => "should favourited once per user" }

end

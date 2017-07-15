class CollectionRestaurant < ActiveRecord::Base
  include ApplicationHelper
  # ============================================================================
  # ASSOCIATION
  # ============================================================================ 
  belongs_to    :collection
  has_many      :restaurant

  # ============================================================================
  # ATTRIBUTES
  # ============================================================================   
  attr_accessible :collection_id, :restaurant_id, :order

end

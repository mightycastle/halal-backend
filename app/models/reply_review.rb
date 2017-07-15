class ReplyReview < ActiveRecord::Base
  # ============================================================================
  # ATTRIBUTES
  # ============================================================================  
  attr_accessible :content, :review_id, :user_id

  # ============================================================================
  # ENUM
  # ============================================================================    
  # Setup searchable attributes for user model   
  RANSACKABLE_ATTRIBUTES = ["content"]

  # ============================================================================
  # INSTANCE - ACTION
  # ============================================================================  
  def self.ransackable_attributes auth_object = nil
    super & RANSACKABLE_ATTRIBUTES
  end
  
end

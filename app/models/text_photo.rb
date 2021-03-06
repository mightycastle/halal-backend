class TextPhoto < ActiveRecord::Base
  # ============================================================================
  # ATTRIBUTES
  # ============================================================================ 
  attr_accessible :title, :content, :photo_id

  # ============================================================================
  # ASSOCIATION
  # ============================================================================ 
  belongs_to :photo
end

class PostMetaWordpress < ActiveRecord::Base
  establish_connection "wordpress-#{Rails.env}"
  self.table_name = "wp_postmeta"

  # ============================================================================
  # INSTANCE - ACTION
  # ============================================================================  
  def self.get_post_icon_category post_id
    post_meta = self.where(meta_key: 'icon_category', post_id: post_id).first
    if post_meta
      post_meta.meta_value
    else
      nil
    end
  end
  
  def self.get_post_view_category post_id
    post_meta = self.where(meta_key: 'text_view_in_home', post_id: post_id).first
    if post_meta
      post_meta.meta_value
    else
      'View top lists'
    end
  end
end
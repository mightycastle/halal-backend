class BasicsPage < ActiveRecord::Base
  include Grape::Entity::DSL
  # ============================================================================
  # ATTRIBUTES
  # ============================================================================
  attr_accessible :id, :page_content, :page_name
  entity do
    expose :get_page_uid                 , as: :page_uid              
    expose :get_page_name                , as: :page_name               
    expose :get_page_content             , as: :content          
  end

  def get_page_uid
    page_uid || ""
  end

  def get_page_name
    page_name || ""
  end

  def get_page_content
    page_content || ""
  end

  def self.footer_info
    footer_page = find_by_page_name("Footer")
    if footer_page.present?
      footer_page.page_content
    else
      I18n.t("footer_layout.info_text")
    end
  end

end

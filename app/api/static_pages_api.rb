require 'grape'

class StaticPagesAPI < Grape::API
  resource :static_pages do
    # faq
    desc "Get static page"
    params do
      requires :id, type: Integer, desc: "1: about us, 2: contact_us, 3: how it work, 4: term & condition, 5: faq"
    end
    route_param :id do 
      get :show do
        case params[:id].to_i
        when 1
          p "about_us"
          page = BasicsPage.find_by_page_uid('about_us')
        when 2
          p "contact_us"
          page = BasicsPage.find_by_page_uid('contact_us')
        when 3
          p "how_work"
          page = BasicsPage.find_by_page_uid('how_work')
        when 4
          p "term_conditions"
          page = BasicsPage.find_by_page_uid('term_conditions')
        when 5
          p "faq"
          page = BasicsPage.find_by_page_uid('faq')
        end
        if page
          response_success I18n.t("service_api.success.get_static_page"), BasicsPage::Entity.represent(page)
        else
          response_error I18n.t("service_api.errors.page_not_found"), 604
        end
      end
    end
  end
end
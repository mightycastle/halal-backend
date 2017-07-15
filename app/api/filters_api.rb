require 'grape'

class FiltersAPI < Grape::API
  resource :filters do

    # Get cuisine list API
    desc "Get cuisine list"
    params do 
    end
    get :cuisine_list do
      authenticate_user
      if(@data = Filter.cuisine.order('name ASC')).blank?
        return response_error I18n.t("service_api.success.none_cuisines"), 1100
      else
        return response_success I18n.t("service_api.success.get_cuisine_list"), Filter::Entity.represent(@data)
      end
    end

    # Get cuisine list API
    desc "Get cuisine list"
    params do 
    end
    get :all do
      authenticate_user
      if(@data = Filter.active).blank?
        return response_error I18n.t("service_api.success.none_cuisines"), 1100
      else
        return response_success I18n.t("service_api.success.get_all_filters"), Filter::Entity.represent(@data)
      end
    end

  end
end


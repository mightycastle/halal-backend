class SearchController < ApplicationController
  layout "application_search_page"

  #=================================================================================
  #  * Method name: by_location
  #  * Input: user params
  #  * Output: create new user
  #  * Date modified: August 24, 2012
  #  * Description: customize create function from devise gem
  #=================================================================================

  def by_location
    @page = params[:page].to_i || 1
    limit = params[:limit].to_i || Restaurant::RESTAURANT_PER_PAGE
    params[:lt] ||= ""
    @zoom_level = params[:zl].present? ? params[:zl].to_i : 10
    @drage = (params[:drage].present? && params[:drage] == 'true') ? true : false
    @ln_name = params[:ln] # use this instead of @location_name for work around
    @filter_ids =  params[:filter_ids].uniq if params[:filter_ids]
    order_by = Restaurant.order_by_query_string(params[:sb])
    filter_time = nil
    filter_time = "#{params[:filter_wday]}-#{params[:filter_time]}" unless params[:filter_wday].to_s.empty? || params[:filter_time].to_s.empty? || params[:search_text_change] == "true"
    @restaurants = Restaurant.search_restaurant(@ln_name, @drage  , params[:llat], params[:llng], @zoom_level, filter_time, @filter_ids, order_by, @page, limit)

    session[:back_to_search_url] = request.fullpath
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    respond_to do |format|
      format.html 
      format.js
    end
  end

end

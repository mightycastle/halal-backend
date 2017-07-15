class RestaurantWaitingApprovesController < ApplicationController
  layout "admin"
  before_filter :authenticate_user!, :required_admin_role
  def index
    @search = RestaurantTemp.search(params[:q])
    @restaurants = @search.result.order("created_at DESC").page(params[:page])
  end

end
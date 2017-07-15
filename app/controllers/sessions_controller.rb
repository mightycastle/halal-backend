class SessionsController < Devise::SessionsController
  def new
    if params[:review]
      session[:review] = params[:review]
      session[:date] = params[:date].present? ? params[:date] : ''
      session[:restaurant_id] = params[:restaurant_id].present? ? params[:restaurant_id] : ''
    end
    # self.resource = resource_class.new(sign_in_params)
    # clean_up_passwords(resource)
    # respond_with(resource, serialize_options(resource))
    super
  end
  #=================================================================================
  #  * Method name: create
  #  * Input: user params
  #  * Output: create new user
  #  * Date modified: August 24, 2012
  #  * Description: customize create function from devise gem
  #=================================================================================
  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:success, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if session[:review].present? && current_user
      @review = current_user.reviews.build(session[:review])
      if session[:date].present? && session[:date][:year].present? && session[:date][:month].present?
        @review.visited_date = DateTime.new(session[:date][:year].to_i, session[:date][:month].to_i,15) 
      end
      @review.restaurant_id = session[:restaurant_id] if session[:restaurant_id].present?
      
      set_flash_message(:success, :review_create_success) if @review.save
      
    end
    session[:review] = nil
    session[:date] = nil
    session[:restaurant_id] = nil
    if resource.is_admin_role?
      redirect_to admin_path
    else      
      respond_with resource, :location => after_sign_in_path_for(resource)
    end
  end
  def destroy
    super
  end

  
end

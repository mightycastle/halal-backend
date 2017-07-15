module Manager

  class RestaurantInfoPageController < ManagerController
    def index
    end

    def update
      check_params(params)
      @restaurant_temp = RestaurantTemp.where(restaurant_id: params[:id]).first
      @restaurant = Restaurant.find(params[:id])
      unless @restaurant_temp
        param_attr = @restaurant.dup.attributes
        param_attr.delete "created_at"
        param_attr.delete "updated_at"
        param_attr.delete "service_avg"
        param_attr.delete "quality_avg"
        param_attr.delete "rating_avg"
        param_attr.delete "value_avg"
        param_attr.delete "menu_uid"
        param_attr.delete "menu_name"
        param_attr.delete "menus"
        param_attr.delete "waiting_for_approve_change"
        param_attr.delete "request_approve_photo"
        param_attr[:restaurant_id] = @restaurant.id
        @restaurant_temp = RestaurantTemp.create(param_attr)
      end
      params[:restaurant][:filter_ids] << params[:restaurant][:filter_id_shisha] if params[:restaurant][:filter_id_shisha]
      params[:restaurant][:filter_ids] << params[:restaurant][:filter_id_alcohol] if params[:restaurant][:filter_id_alcohol]
      params[:restaurant][:filter_ids] << params[:restaurant][:filter_id_price] if params[:restaurant][:filter_id_price]
      params[:restaurant].delete 'filter_id_shisha'
      params[:restaurant].delete 'filter_id_alcohol'
      params[:restaurant].delete 'filter_id_price'
      if params[:restaurant][:filter_ids] != nil
        @restaurant_temp.filter_ids = params[:restaurant][:filter_ids]
        @restaurant_temp.save
      end
      respond_to do |format|
        if params[:restaurant][:image].present?
          params[:image] = []
          params[:image] = params[:restaurant][:image]
          params[:restaurant].delete "image"
        end
        schedules = @restaurant_temp.schedules
        if schedules
          schedules.each do |sch|
            sch.destroy
          end
        end
        params[:restaurant][:schedules_attributes].each do |a|
          a[1].delete 'id'
        end

        if @restaurant_temp.update_attributes(params[:restaurant])
          if params[:image].present?
            if params[:image].class.to_s == "ActionDispatch::Http::UploadedFile"
              @p = @restaurant_temp.photos.create(image: params[:image], restaurant_temp_id: @restaurant_temp.try(:id), :user_id => current_user.id)
            else
              @restaurant_temp.photos.create(image: ActionDispatch::Http::UploadedFile.new(params[:image]), restaurant_temp_id: @restaurant_temp.try(:id), :user_id => current_user.id)
            end
          end
        end
        format.html { redirect_to manager_restaurant_info_edit_path(@restaurant.id), notice: I18n.t('restaurant.update_wait_approve') }
        format.json { head :no_content }
      end
    end

    def edit
      @restaurant = current_restaurant

      if @restaurant.schedules.blank?
        (1..7).each {|i| @restaurant.schedules.build(day_of_week: i)}
      elsif @restaurant.schedules.is_daily.blank?
        (1..7).each {|i| @restaurant.schedules.build(day_of_week: i, schedule_type: 'daily')}
      elsif @restaurant.schedules.is_evening.blank?
        (1..7).each {|i| @restaurant.schedules.build(day_of_week: i, schedule_type: 'evening')}
      end

      @restaurant.photos.build if @restaurant.photos.blank?

      @menu = Menu.new(restaurant_id: @restaurant.id)
      cuisine = @restaurant.filters.where(code: 'cuisine')
       @filter_cuisine_id = []
      if cuisine.length > 0
        cuisine.each do |c| @filter_cuisine_id << c.id end
      end

      @filter_ids = @restaurant.filter_ids

      filter_type_hal_status = FilterType.where(code: 'hal_status').first
      @filter_status = filter_type_hal_status.filters if filter_type_hal_status


      filter_type_price = FilterType.where(code: 'price').first
      @filter_prices = filter_type_price.filters if filter_type_price

      # filter_type_facilities = FilterType.where(code: 'facility').first
      # @filter_facilities = filter_type_facilities.filters if filter_type_facilities

      filter_type_cuisine = FilterType.where(code: 'cuisine').first
      @filter_cuisines = filter_type_cuisine.filters.order('name ASC') if filter_type_cuisine

      # filter_type_shisha = FilterType.where(code: 'shisha').first
      # @filter_shisha = filter_type_shisha.filters if filter_type_shisha

      filter_type_alcohol = FilterType.where(code: 'alcohol').first
      @filter_alcohol = filter_type_alcohol.filters if filter_type_alcohol

      # filter_type_organic = FilterType.where(code: 'organic').first
      # @filter_organic = filter_type_organic.filters if filter_type_organic

      filter_type_features = FilterType.where(code: 'features').first
      @filter_features = filter_type_features.filters.where_not_offer if filter_type_features
    end

    private

      def check_params(params)
        params[:restaurant][:email] = "" if params[:restaurant][:email] == "Email"
        params[:restaurant][:phone] = "" if params[:restaurant][:phone] == "Phone"
        params[:restaurant][:name] = "" if params[:restaurant][:name] == "Name"
        params[:restaurant][:address] = "" if params[:restaurant][:address] == "Location"
        params[:restaurant][:short_address] = "" if params[:restaurant][:short_address] == "Address"
        params[:restaurant][:website] = "" if params[:restaurant][:website] == "Website"
        params[:restaurant][:city] = "" if params[:restaurant][:city] == "City"
        params[:restaurant][:district] = "" if params[:restaurant][:district] == "District"
        params[:restaurant][:country] = "" if params[:restaurant][:country] == "Country"
        params[:restaurant][:lat] = "" if params[:restaurant][:lat] == "Latitude"
        params[:restaurant][:lng] = "" if params[:restaurant][:lng] == "Longitude"
      end

  end
end

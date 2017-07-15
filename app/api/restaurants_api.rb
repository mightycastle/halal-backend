class RestaurantsAPI < Grape::API

  resource :restaurants do
    # Create restaurant API
    desc "Create restaurant"
    params do 
      requires :name            ,type: String, desc: "Restaurant's name"
      requires :city            ,type: String, desc: "Restaurant's city"
      requires :email           ,type: String, desc: "Restaurant's email"
      requires :address         ,type: String, desc: "Restaurant's address"
      requires :phone           ,type: String, desc: "Restaurant's phone"

      optional :service         ,type: Integer, desc: "First review service"
      optional :quality         ,type: Integer, desc: "First review quality"
      optional :value           ,type: Integer, desc: "First review value"
      optional :content         ,type: String, desc: "First review content"
      optional :month           ,type: Integer, desc: "First review date month"
      optional :year            ,type: Integer, desc: "First review date year"

      optional :suggester_name  ,type: String, desc: "Restaurant's suggester name"
      optional :suggester_email ,type: String, desc: "Restaurant's suggester email"
      optional :suggester_phone ,type: String, desc: "Restaurant's suggester phone"
      optional :website         ,type: String, desc: "Restaurant's website"
    end
    post :create do
      authenticate_user
      @result = @user.restaurants.create_with_params params
      if @result[:success] == true
        return response_success @result[:message], @result[:data]
      else
        return response_error @result[:message], @result[:error]
      end
    end

    # Get restaurant detail API
    desc "Get restaurant detail"
    params do 
      requires :restaurant_id ,type: String, desc: "Restaurant's ID"
      optional :page_size     ,type: String, desc: "Page's size"
      optional :page_index    ,type: String, desc: "Page's index"
    end
    route_param :restaurant_id do 
      get :detail do
        authenticate_user
        @result = Restaurant.actions_with_params params, "get_detail", @user
        if @result[:success] == true
          return response_success @result[:message], @result[:data]
        else
          return response_error @result[:message], @result[:error]
        end
      end
    end

    # Get restaurant menus API
    desc "Get restaurant menus"
    params do 
      requires :restaurant_id ,type: String, desc: "Restaurant's ID"
    end
    route_param :restaurant_id do 
      get :menus do
        authenticate_user
        @result = Restaurant.actions_with_params params, "get_menus"
        if @result[:success] == true
          return response_success_array @result[:message], @result[:data]
        else
          return response_error @result[:message], @result[:error]
        end
      end
    end

    # Add restaurant's review API
    desc "Add restaurant's review"
    params do 
      requires :restaurant_id ,type: String, desc: "Restaurant's ID"
      requires :service         ,type: Integer, desc: "Review service"
      requires :quality         ,type: Integer, desc: "Review quality"
      requires :value           ,type: Integer, desc: "Review value"
      requires :content         ,type: String, desc: "Review content"
      requires :month           ,type: Integer, desc: "Review date month"
      requires :year            ,type: Integer, desc: "Review date year"
    end
    route_param :restaurant_id do 
      post "reviews/create" do
        authenticate_user
        @result = Restaurant.actions_with_params params, "add_review"
        if @result[:success] == true
          return response_success @result[:message], @result[:data]
        else
          return response_error @result[:message], @result[:error]
        end
      end
    end

    # Get restaurant's reviews list API
    desc "Get restaurant's reviews list"
    params do 
      requires :restaurant_id ,type: String, desc: "Restaurant's ID"
      optional :page_size     ,type: String, desc: "Page's size"
      optional :page_index    ,type: String, desc: "Page's index"
    end
    route_param :restaurant_id do 
      get "reviews/list" do
        authenticate_user
        @result = Restaurant.actions_with_params params, "get_list_reviews"
        if @result[:success] == true
          return response_success_array @result[:message], @result[:data]
        else
          return response_error @result[:message], @result[:error]
        end
      end
    end

    # Get restaurant's favourite list API
    desc "Get restaurant's favourite list"
    params do 
      optional :page_size     , type: String, desc: "Page's size"
      optional :page_index    , type: String, desc: "Page's index"
      optional :lat           , type: BigDecimal, desc: "Current's lat"
      optional :long          , type: BigDecimal, desc: "Current's long"
    end
    get "favourite_list" do
      authenticate_user
      @result = @user.get_list_favourites_restaurant_with_params params
      if @result[:success] == true
        return response_success_array @result[:message], @result[:data]
      else
        return response_error @result[:message], @result[:error]
      end
    end

    # Add retaurant to favourite list API
    desc "Add retaurant to favourite list"
    params do 
      requires :restaurant_id ,type: String, desc: "Restaurant's ID"
    end
    route_param :restaurant_id do 
      post "add_to_favourite_list" do
        authenticate_user
        @result = @user.add_to_favourite_list_with_params params
        if @result[:success] == true
          return response_success @result[:message], @result[:data]
        else
          return response_error @result[:message], @result[:error]
        end
      end
    end

    # Remove retaurant from favourite list API
    desc "Remove retaurant from favourite list"
    params do 
      requires :restaurant_id ,type: String, desc: "Restaurant's ID"
    end
    route_param :restaurant_id do 
      post "remove_from_favourite_list" do
        authenticate_user
        @result = @user.remove_from_favourite_list_with_params params
        if @result[:success] == true
          return response_success @result[:message], @result[:data]
        else
          return response_error @result[:message], @result[:error]
        end
      end
    end

    # Search restaurants API
    desc "Search restaurants"
    params do 
      optional :key_search          , type: String, desc: " Location, restaurant name"
      optional :zoom_level    , type: Integer, desc: "Zoom level"
      optional :page_size     , type: Integer, desc: "Page's size"
      optional :page_index    , type: Integer, desc: "Page's index"
      optional :lat           , type: BigDecimal, desc: "Current's lat"
      optional :long          , type: BigDecimal, desc: "Current's long"
      optional :filter_ids    , type: String, desc: "String contain array of 'filter_type_id, filter_id' like ['1,2', '3,4']"
    end
    get "search" do
      key_search = params[:key_search]
      page_size = params[:page_size]
      page_index = params[:page_index].to_i || 1
      zoom_level = params[:zoom_level].present? ? params[:zoom_level].to_i : 7
      redo_search_in_map = params[:rds].present? ? params[:rds] : false

      filter_ids =  eval(params[:filter_ids]).uniq if params[:filter_ids]
      order_by = Restaurant.order_by_query_string(nil)

      @data = Restaurant.search_restaurant(key_search, false, params[:lat], params[:long], zoom_level, nil, filter_ids, order_by, page_index, page_size)
      if @data.present?
        return response_success I18n.t( "service_api.success.get_list_by_name" ), Restaurant::Entity.represent( @data, favourite_list: true )
      else
        return response_error I18n.t( "service_api.success.none_restaurants" ), 1006
      end
    end

  end
end


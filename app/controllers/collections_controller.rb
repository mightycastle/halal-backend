class CollectionsController < ApplicationController
  # GET /collections
  # GET /collections.json
  layout 'admin', :except => ['new', 'create', 'show', 'offer']
  before_filter :authenticate_user!, :required_admin_role, only: [:collections, :admin_new_collection, :edit_collection, :update, :add_restaurant]

  REVIEW_PER_PAGE = 10
  # =================================================================================
  #  * Method name: index
  #  * Input:
  #  * Output: Collection name, Collection description, Collection image_url
  #  * Date modified: January 14, 2016
  #  * Description: Allows the administrator to see existing collections
  # =================================================================================
  def index
    @search = Collection.search(params[:q])
    result = @search.result
    @collections = result.order('name ASC, created_at DESC').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collections }
    end
  end

  # =================================================================================
  #  * Method name: collections
  #  * Input:
  #  * Output: Collection name, Collection description, Collection image_url
  #  * Date modified: January 12, 2016
  #  * Description: Pulls data about collections and paginates results in table
  # =================================================================================
  def collections
    @search = Collection.search(params[:q])
    @collections = @search.result.order('name ASC, created_at DESC').page(params[:page])
    @collections = Kaminari.paginate_array(@collections).page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collections }
    end
  end

  # =================================================================================
  #  * Method name: admin_new_collection
  #  * Input: Collection name, Collection description, Collection image_url
  #  * Output:
  #  * Date modified: January 12, 2016
  #  * Description: Allows the administrator adding new collections
  # =================================================================================
  # GET /collections/admin_new_collection
  # GET /restaurants/admin_new_collection.json
  def admin_new_collection
    @collection = Collection.new
    @restaurants = Restaurant.where(disabled: false)
    @collection_restaurant = CollectionRestaurant.new
    respond_to do |format|
      format.html # new_collection.html.erb
      format.json { render json: @collection }
    end
  end

  # =================================================================================
  #  * Method name: create
  #  * Input: Collection name, Collection description, Collection image_url
  #  * Output:
  #  * Date modified: January 17, 2016
  #  * Description: Allows the administrator adding new collections
  # =================================================================================
  # POST /collections
  # POST /collections.json
  def create
    if params[:admin] == 'true'

    end

    @collection = Collection.where(name: params[:collection][:name]).first
    respond_to do |format|
      if @collection.blank?
        @collection = Collection.new(params[:collection])
        if params[:collection_image]
          @collection.collection_image = CollectionImage.new(params[:collection_image])
        end
        if @collection.save
          session[:collection_id] = @collection.id
          @collection.update_image_url
        else
          format.html { render action: "admin_new_collection", layout: 'admin' }
          format.json { render json: @collection.errors, status: :unprocessable_entity }
        end
      elsif params[:admin] == 'true'
        # cheat to keep input value retain
        build_new_collection(params[:collection])
        flash[:error] = I18n.t('collections.collection_exist')
        render 'collections/admin_new_collection', layout: 'admin'
        return
      end
      # response
      format.html { redirect_to edit_collection_path(session[:collection_id]), notice: I18n.t('collections.create_success') }
    end
  end

  # =================================================================================
  #  * Method name: edit_collection
  #  * Input:
  #  * Output:
  #  * Date modified: January 14, 2016
  #  * Description: Allows the administrator editing collections
  # =================================================================================
  # GET /collection/1/edit
  def edit_collection
    @collection = Collection.find(params[:id])
    @restaurants = Restaurant.where(disabled: false)
    @collection_restaurant = CollectionRestaurant.new

    @collection_restaurants = @collection.restaurants
  end

  # =================================================================================
  #  * Method name: update
  #  * Input:
  #  * Output:
  #  * Date modified: January 14, 2016
  #  * Description: Allows the administrator saving updated collection
  # =================================================================================
  # PUT /collections/1
  # PUT /collections/1.json
  def update
    check_params(params)
    @collection = Collection.find(params[:id])
    if params[:collection_image]
      # @collection_image = CollectionImage.new(params[:collection_image])
      if @collection.collection_image.blank?
        @collection.collection_image = CollectionImage.new(params[:collection_image])
        @collection.collection_image.save
      else
        @collection.collection_image.update_attributes(params[:collection_image])
      end
      @collection.update_image_url
    end

    respond_to do |format|
      if @collection.update_attributes(params[:collection])
        @collection.save
        format.html { redirect_to edit_collection_path(@collection.id), notice: I18n.t('collections.update_success') }
        format.json { head :no_content }
      end
    end
  end

  # =================================================================================
  #  * Method name: check_params
  #  * Input:
  #  * Output:
  #  * Date modified: January 14, 2016
  #  * Description: Checking if parameters have been passed
  # =================================================================================
  def check_params(params)
    params[:collection][:name] = '' if params[:collection][:name] == 'Name'
    params[:collection][:description] = '' if params[:collection][:description] == 'Description'
  end

  # =================================================================================
  #  * Method name: build_new_collection
  #  * Input:
  #  * Output:
  #  * Date modified: January 14, 2016
  #  * Description: Checking if parameters have been passed
  # =================================================================================
  def build_new_collection(options={})
    @collection = Collection.new(options)
  end

  #=================================================================================
  #  * Method name: disable_toggle
  #  * Input: restaurant_id
  #  * Output: disable/enable restaurant
  #  * Date modified: January 17, 2015
  #  * Description:
  #=================================================================================
  def disable_toggle
    @collection = Collection.find(params[:id])
    if @collection.disable_toggle
      render template: "collections/disable_toggle"
    else
      render template: "collections/disable_toggle_error"
    end

  end

  #=================================================================================
  #  * Method name: add_restaurant
  #  * Input: id (collection_id), restaurant_id
  #  * Output: whole restaurants list
  #  * Date modified: January 17, 2015
  #  * Description:
  #=================================================================================
  def add_restaurant
    status = 'failed'
    tr = 'collections.update_failed'
    #respond_to do |format|
      if params[:collection_restaurant][:restaurant_id].present?
        restaurant_id = params[:collection_restaurant][:restaurant_id];
        @collection = Collection.find(params[:id])
        restaurant = Restaurant.find(restaurant_id)

        @collection.restaurants << restaurant unless @collection.restaurants.include?(restaurant)

        status = 'success';
        tr = 'collections.update_success'

      end
      render template: "collections/_collection_restaurants_list"
    #  format.html { redirect_to edit_collection_path(params[:id]), notice: I18n.t(tr) }
    #  format.json { render json: status }
    #end
  end

  # =================================================================================
  #  * Method name: remove_restaurant
  #  * Input: id (collection_id), restaurant_id
  #  * Output: remove restaurant item
  #  * Date modified: January 14, 2016
  #  * Description: Allows the administrator deleting collection
  # =================================================================================
  # DELETE /collections/1
  # DELETE /collections/1.json
  def remove_restaurant
    @status = 'failed'
    tr = 'collections.update_failed'
    @collection = Collection.find(params[:id])
    if @collection.present?
      if params[:restaurant_id].present?
        @restaurant_id = params[:restaurant_id]
        restaurant = @collection.restaurants.find(@restaurant_id)
        if restaurant
          @collection.restaurants.delete(restaurant)
          @status = "success"
          tr = 'collections.update_success'
        end
      end
    end

    render template: "collections/remove_restaurant"
  end

  # =================================================================================
  #  * Method name: destroy
  #  * Input:
  #  * Output:
  #  * Date modified: January 14, 2016
  #  * Description: Allows the administrator deleting collection
  # =================================================================================
  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection = Collection.find(params[:id])
    @collection.destroy

    respond_to do |format|
      format.html { redirect_to collections_url }
      format.json { head :no_content }
    end
  end
end

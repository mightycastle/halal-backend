class PhotosController < ApplicationController
  # before_filter :authenticate_user!, :require_profession_user, only:[:create]
  #=================================================================================
  #  * Method name: index
  #  * Input: r_id
  #  * Output: list photos of a restaurant
  #  * Date modified: August 30, 2012
  #  * Description: this json data of restaurant are used for uploading
  #=================================================================================
  def index
    @restaurant = Restaurant.find(params[:r_id])
    @photos = @restaurant.photos
    render :json => @photos.collect { |p| p.to_jq_upload }.to_json
  end
  #=================================================================================
  #  * Method name: create
  #  * Input: params photo
  #  * Output: update photos for a restaurant
  #  * Date modified: August 30, 2012
  #  * Description: 
  #=================================================================================
  def create
    p_attr = params[:photo]
    restaurant_id = params[:photo][:restaurant_id]
    p_attr[:image] = params[:photo][:image].first if params[:photo][:image].class == Array
    restaurant = Restaurant.find(restaurant_id) if restaurant_id

    @photo = Photo.new(p_attr)
    if @photo.save
      restaurant.update_attribute('updated_at', Time.now) if restaurant
      if current_user && current_user.is_admin_role?
        @photo.status = 1
        @photo.save
      end
      respond_to do |format|
        format.html {  
          render :json => [@photo.to_jq_upload].to_json, 
          :content_type => 'text/html',
          :layout => false
        }
        format.json {  
          render :json => [@photo.to_jq_upload].to_json			
        }
      end
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    render :json => true
  end

  def reject
    @photo = Photo.find(params[:id])
    @photo.status = 2
    @photo.save
    respond_to do |format|
      format.js
    end
  end

  def approve
    @photo = Photo.find(params[:id])
    @photo.status = 1
    @photo.save
    respond_to do |format|
      format.js
    end
  end
  #=================================================================================
  #  * Method name: to_cover
  #  * Input: params photo id
  #  * Output: update covered photo of a restaurant
  #  * Date modified: August 30, 2012
  #  * Description: 
  #=================================================================================
  def to_cover
    @photo = Photo.find(params[:id])
    @photo.to_cover
#    render :json => true
  end

  def update_text_photo
    @photo = AdminPhoto.find(params[:id])    
    if @photo.update_attributes(params[:text_photo])
      render :json => @photo
    end
  end

end

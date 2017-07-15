class CollectionImagesController < ApplicationController
  #=================================================================================
  #  * Method name: index
  #  * Input: r_id
  #  * Output: list CollectionImage of a collection
  #  * Date modified: January 15, 2016
  #  * Description: this json data of collection is used for uploading
  #=================================================================================
  def index
    @collection = Collection.find(params[:r_id])
    @collection_image = @collection.collection_image
    render :json => @collection_image.collect { |ci| ci.to_jq_upload }.to_json
  end

  #=================================================================================
  #  * Method name: create
  #  * Input: params CollectionImage
  #  * Output: update CollectionImage for a collection
  #  * Date modified: January 15, 2016
  #  * Description: 
  #=================================================================================
  def create
    p_attr = params[:collection_image]
    collection_id = params[:collection_image][:collection_id]
    p_attr[:image] = params[:collection_image][:image].first if params[:collection_image][:image].class == Array
    collection = Collection.find(collection_id) if collection_id

    @collection_image = CollectionImage.new(p_attr)
    if @collection_image.save
      collection.update_attribute('updated_at', Time.now) if collection
      if current_user && current_user.is_admin_role?
        @collection_image.save
      end
      respond_to do |format|
        format.html {  
          render :json => [@collection_image.to_jq_upload].to_json, 
          :content_type => 'text/html',
          :layout => false
        }
        format.json {  
          render :json => [@collection_image.to_jq_upload].to_json			
        }
      end
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  #=================================================================================
  #  * Method name: destroy
  #  * Input: params CollectionImage
  #  * Output: delete CollectionImage for a collection
  #  * Date modified: January 15, 2016
  #  * Description:
  #=================================================================================
  def destroy
    @collection_image = CollectionImage.find(params[:id])
    @collection_image.destroy
    render :json => true
  end

end

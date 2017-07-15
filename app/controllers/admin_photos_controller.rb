class AdminPhotosController < ApplicationController
  layout "admin"
  before_filter :authenticate_user!, :required_admin_role

  PER_PAGE = 30
  #=================================================================================
  #  * Method name: admin_upload_photos
  #  * Input: param page
  #  * Output: list photos for showing in home page
  #  * Date modified: August 31, 2012
  #  * Description: get list photos 
  #=================================================================================
  def admin_upload_photos
    page = params[:page] || 1 
    @admin_photos_all = AdminPhoto.all   
    #@admin_photos = AdminPhoto.page(page).per(PER_PAGE)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_photos }
    end
  end
  #=================================================================================
  #  * Method name: index
  #  * Input: current_user
  #  * Output: list photos uploading by admin(current_user)
  #  * Date modified: August 31, 2012
  #  * Description: get list photos 
  #=================================================================================
  def index
    @photos = AdminPhoto.all
    render :json => @photos.collect { |p| p.to_jq_upload }.to_json
  end

  # GET /admin_photos/1
  # GET /admin_photos/1.json
  def show
    @admin_photo = AdminPhoto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_photo }
    end
  end

  # GET /admin_photos/new
  # GET /admin_photos/new.json
  def new
    @admin_photo = AdminPhoto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_photo }
    end
  end

  # GET /admin_photos/1/edit
  def edit
    @admin_photo = AdminPhoto.find(params[:id])
  end

  # POST /admin_photos
  # POST /admin_photos.json
  def create
    p_attr = params[:admin_photo]
    p_attr[:image] = params[:admin_photo][:image].first if params[:admin_photo][:image].class == Array

    @photo = AdminPhoto.new(p_attr)
    if @photo.save
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

  # PUT /admin_photos/1
  # PUT /admin_photos/1.json
  def update
    @admin_photo = AdminPhoto.find(params[:id])

    respond_to do |format|
      if @admin_photo.update_attributes(params[:admin_photo])
        format.html { redirect_to @admin_photo, notice: I18n.t('admin_photo.update_success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_photos/1
  # DELETE /admin_photos/1.json
  def destroy
    @admin_photo = AdminPhoto.find(params[:id])
    @admin_photo.destroy

    respond_to do |format|
      format.html { redirect_to admin_upload_photos_path }
      format.json { head :no_content }
    end
  end
  #=================================================================================
  #  * Method name: change_image_type
  #  * Input: params photo id
  #  * Output: update image_type
  #  * Date modified: August 30, 2012
  #  * Description: 
  #=================================================================================
  def change_image_type
    @photo = AdminPhoto.find(params[:id])
    @photo.image_type = (@photo.image_type == true ? false : true )
    @photo.save
    respond_to do |format|
      format.js
    end
  end

  private
  #=================================================================================
  #  * Method name: required_admin_login
  #  * Input: n/a
  #  * Output: check current_user is admin or normal user
  #  * Date modified: August 25, 2012
  #  * Description: check current_user is admin or normal user
  #=================================================================================
  def required_admin_login
    if !current_user || !current_user.admin_role
      flash[:notice] = I18n.t('admin_photo.required_role')
      redirect_to new_user_session_path
    end
  end

end

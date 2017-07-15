class FiltersController < ApplicationController
  layout 'admin'

  before_filter :authenticate_user!, :required_admin_role
  #before_filter :required_admin_role, :only=>[:index, :destroy, :change_status]
  #=================================================================================
  #  * Method name: index
  #  * Input: page
  #  * Output: 
  #  * Date modified: August 30, 2012
  #  * Description: get list filters for admin management
  #=================================================================================
  def index
    @search = Filter.search(params[:q] )
    @filters = @search.result.page(params[:page])
    @filter = Filter.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @filters }
    end
  end

  # GET /filters/1
  # GET /filters/1.json
  def show
    @filter = Filter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @filter }
    end
  end

  # GET /filters/new
  # GET /filters/new.json
  def new
    @filter = Filter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @filter }
    end
  end

  # GET /filters/1/edit
  def edit
    @filter = Filter.find(params[:id])
  end

  # POST /filters
  # POST /filters.json
  def create
    @filter = Filter.new(params[:filter])

    respond_to do |format|
      if @filter.save
        format.html { redirect_to @filter, notice: I18n.t('filter.create_success') }
        format.json { render json: @filter, status: :created, location: @filter }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /filters/1
  # PUT /filters/1.json
  def update
    @filter = Filter.find(params[:id])

    respond_to do |format|
      if @filter.update_attributes(params[:filter])
        format.html { redirect_to @filter, notice: I18n.t('filter.update_success') }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_name
    @filter = Filter.find(params[:id])
    @filter.name = params[:name]
    @filter.save
    respond_to do |format|
      format.js
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.json
  def destroy
    @filter = Filter.find(params[:id])
    @filter.destroy

    respond_to do |format|
      format.html { redirect_to filters_url }
      format.json { head :no_content }
    end
  end

  #=================================================================================
  #  * Method name: change_status
  #  * Input: user_id, status
  #  * Output: update status of a filter
  #  * Date modified: August 30, 2012
  #  * Description: update status of a filter
  #=================================================================================
  def change_status
    @filter = Filter.find(params[:id])
    if @filter.update_attributes(:status => params[:status])
      render template: "filters/change_status"
    else
      render template: "filters/change_status_error"
    end
  end

end

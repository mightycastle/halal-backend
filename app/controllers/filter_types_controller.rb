class FilterTypesController < ApplicationController
  layout 'admin'

  # GET /filter_types
  # GET /filter_types.json
  def index
    @filter_types = FilterType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @filter_types }
    end
  end

  # GET /filter_types/1
  # GET /filter_types/1.json
  def show
    @filter_type = FilterType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @filter_type }
    end
  end

  # GET /filter_types/new
  # GET /filter_types/new.json
  def new
    @filter_type = FilterType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @filter_type }
    end
  end

  # GET /filter_types/1/edit
  def edit
    @filter_type = FilterType.find(params[:id])
  end

  # POST /filter_types
  # POST /filter_types.json
  def create
    @filter_type = FilterType.new(params[:filter_type])

    respond_to do |format|
      if @filter_type.save
        format.html { redirect_to @filter_type, notice: 'Filter type was successfully created.' }
        format.json { render json: @filter_type, status: :created, location: @filter_type }
      else
        format.html { render action: "new" }
        format.json { render json: @filter_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /filter_types/1
  # PUT /filter_types/1.json
  def update
    @filter_type = FilterType.find(params[:id])

    respond_to do |format|
      if @filter_type.update_attributes(params[:filter_type])
        format.html { redirect_to @filter_type, notice: 'Filter type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @filter_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filter_types/1
  # DELETE /filter_types/1.json
  def destroy
    @filter_type = FilterType.find(params[:id])
    @filter_type.destroy

    respond_to do |format|
      format.html { redirect_to filter_types_url }
      format.json { head :no_content }
    end
  end
end

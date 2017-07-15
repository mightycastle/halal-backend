class PlanTypesController < ApplicationController
  before_filter :required_user_login
  # GET /plan_types
  # GET /plan_types.json
  def index
    @plan_types = PlanType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plan_types }
    end
  end

  # GET /plan_types/1
  # GET /plan_types/1.json
  def show
    @plan_type = PlanType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plan_type }
    end
  end

  # GET /plan_types/new
  # GET /plan_types/new.json
  def new
    @plan_type = PlanType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plan_type }
    end
  end

  # GET /plan_types/1/edit
  def edit
    @plan_type = PlanType.find(params[:id])
  end

  # POST /plan_types
  # POST /plan_types.json
  def create
    @plan_type = PlanType.new(params[:plan_type])

    respond_to do |format|
      if @plan_type.save
        format.html { redirect_to @plan_type, notice: 'Plan type was successfully created.' }
        format.json { render json: @plan_type, status: :created, location: @plan_type }
      else
        format.html { render action: "new" }
        format.json { render json: @plan_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plan_types/1
  # PUT /plan_types/1.json
  def update
    @plan_type = PlanType.find(params[:id])

    respond_to do |format|
      if @plan_type.update_attributes(params[:plan_type])
        format.html { redirect_to @plan_type, notice: 'Plan type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plan_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plan_types/1
  # DELETE /plan_types/1.json
  def destroy
    @plan_type = PlanType.find(params[:id])
    @plan_type.destroy

    respond_to do |format|
      format.html { redirect_to plan_types_url }
      format.json { head :no_content }
    end
  end
end

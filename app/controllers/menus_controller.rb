class MenusController < ApplicationController
  def index
    @restaurant = Restaurant.find(params[:r_id])
    @menus = @restaurant.menus
    render :json => @menus.collect { |p| p.to_jq_upload }.to_json
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @menu = Menu.new(params[:menus])
    @menu.user_id = current_user.id 
    
    respond_to do |format|
      if @menu.save
        flash[:notice] = I18n.t('menu.create_success')
        format.html {  
          render :json => [@menu.to_jq_upload].to_json, 
          :content_type => 'text/html',
          :layout => false
        }
        format.json {  
          render :json => [@menu.to_jq_upload].to_json     
        }
      else

        flash[:notice] = I18n.t('menu.create_fail')
        format.html { redirect_to restaurant_info_path(@menu.restaurant.slug)}
        format.json { render json: @menu.errors, status: :unprocessable_entity }
        format.js { render 'error'}
      end
    end
  end

  def update
    @menu = Menu.find(params[:id])

    respond_to do |format|
      if @menu.update_attributes(params[:menu])
        format.html { redirect_to @menu, notice: I18n.t('menu.update_success') }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy

    respond_to do |format|
      format.html { redirect_to menu_url }
      format.json { head :no_content }
      format.js
    end
  end
end

class BasicsPagesController < ApplicationController
  layout "admin"
  before_filter :authenticate_user!, :required_admin_role
  def index
    @pages = BasicsPage.all
    @page = BasicsPage.first(:order=>"id ASC")
  end
  def edit
    @pages = BasicsPage.all
    @page = BasicsPage.find(params[:id])
  end
  def update
    @page = BasicsPage.find(params[:id])
    @page.update_attribute(:page_content, params[:basics_page][:page_content])
    if @page.save
      flash[:success] = "Page content has been updated successfully!"
    else
      flash[:error] = "Please try again!"
    end
    redirect_to edit_basics_page_path(@page)
  end
end

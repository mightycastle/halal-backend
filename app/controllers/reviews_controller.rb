class ReviewsController < ApplicationController
  # GET /reviews
  # GET /reviews.json
  layout 'admin'
  before_filter :required_user_login, :only=>[:update_reply_content, :change_approve_reply, :reply_review, :set_featured, :index, :destroy, :change_status, :admin_review_replies, :update_review]
  before_filter :required_admin_role, :only=>[:update_reply_content, :change_approve_reply, :set_featured, :index, :destroy, :change_status, :admin_review_replies, :update_review]
  PER_PAGE = 30
  #=================================================================================
  #  * Method name: index
  #  * Input: param q (Ransack gem)
  #  * Output: list users
  #  * Date modified: August 25, 2012
  #  * Description: get list reviews for admin management
  #=================================================================================
  def index
    @search = Review.search(params[:q])
    if params[:commit].blank? && params[:q].blank?
      @reviews = Review.order("created_at DESC").page(params[:page]).per(PER_PAGE)
    else
      @reviews = @search.result.page(params[:page]).per(PER_PAGE)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviews }
    end
  end

  def show
    @review = Review.find(params[:id])
    redirect_to restaurant_info_path(@review.restaurant.slug)
  end

  def new
    @review = Review.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @review }
    end
  end


  def update
    @review = Review.find(params[:id])
    respond_to do |format|
    #   if @review.update_attributes(params[:review])
        format.html { redirect_to admin_reviews_path }
    #     format.json { head :no_content }
    #     format.js
    #   else
    #     format.html { render action: "edit" }
    #     format.json { render json: @review.errors, status: :unprocessable_entity }
    #   end
    end
  end

  def update_reply_content
    @review = Review.find(params[:id])
    @review.reply_content = params[:reply_content]
    @review.save
    respond_to do |format|
      format.js
    end
  end

  def update_review
    @review = Review.find(params[:id])
    @review.restaurant_id =  params[:review][:restaurant_id] if params[:review][:restaurant_id].present?
    @review.content = params[:review][:content]
    @review.save
    respond_to do |format|
      format.html{redirect_to admin_reviews_path}
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to reviews_url }
      format.json { head :no_content }
    end
  end
  #=================================================================================
  #  * Method name: change_status
  #  * Input: id
  #  * Output: change status of a review
  #  * Date modified: August 27, 2012
  #  * Description: 
  #=================================================================================
  def change_status
    @review = Review.find(params[:id])
    if @review.change_status(params[:status])
      render template: "reviews/change_status"
      if params[:status].to_s == 0.to_s
        @review.feature_review = false
        @review.save
        if !@review.user.nil?
          @email = UserMailer.send_reject_review(@review.user.email, @review).deliver
        end
      end
    else
      render template: "reviews/change_status_error"
    end
  end


  def set_featured
    @review = Review.find_by_id(params[:id])
    respond_to do |format|
      if @review.restaurant.reviews.where(feature_review: true).length < 3 && params[:status].to_i == 1
        if @review.update_attribute('feature_review', params[:status])
          format.js
        end
      else
        @review_id = @review.id
        @message = t('review.warning_message_feature')
        format.js
      end
    end
  end
  #=================================================================================
  #  * Method name: change_approve_reply
  #  * Input: id
  #  * Output: change status of a review
  #  * Date modified: August 27, 2012
  #  * Description: 
  #=================================================================================
  def change_approve_reply
    @review = Review.find(params[:id])
    if @review.change_approve_reply(params[:approve_reply])
      render template: "reviews/change_approve_reply"
      if params[:approve_reply].to_s == 0.to_s
        @user =  User.find(@review.user_reply)
        if @user.present?
          @email = UserMailer.send_reject_reply(@user.email , @review).deliver
        end
      end
    else
      render template: "reviews/change_approve_reply_error"
    end
  end
  #=================================================================================
  #  * Method name: my_reviews
  #  * Input: current_user
  #  * Output: list reviews of current user
  #  * Date modified: September 04, 2012
  #  * Description: 
  #=================================================================================
  def my_reviews
    if current_user.admin_role
      redirect_to reviews_path
    else
      @reviews = Review.where(:user_id=>current_user.id).order("created_at").page(params[:page])
      respond_to do |format|
        format.html # my_reviews.html.erb
        format.json { render json: @reviews }
      end
    end
  end

  def reply_review

    params[:reply_review][:reply_time] = Time.now
    @review = Review.find_by_id(params[:review_id])
    if @review.present? && current_user.id == @review.restaurant.user_id 
      params[:reply_review][:user_reply] = current_user.id 
      if @review.update_attributes(params[:reply_review])
       
        respond_to do |format|
          format.js
        end
      end
    end
  end
  
  def admin_review_replies
    @search = Review.search(params[:q])
    if params[:commit].blank? && params[:q].blank?
      @reviews = Review.review_reply.order("updated_at DESC").page(params[:page]).per(PER_PAGE)
    else
      @reviews = @search.result.page(params[:page]).per(PER_PAGE)
    end
    respond_to do |format|
      format.html # index.html.erb

    end
  end
end

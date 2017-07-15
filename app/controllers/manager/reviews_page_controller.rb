module Manager

  class ReviewsPageController < ManagerController
    def index
      @reviews = get_current_restaurant_reviews
    end

    def show_review
      @review = Review.find params[:review_id]
      @reviewer = @review.user

      respond_to do |format|
        format.js
        format.html { redirect_to manager_reviews_path(r: @review.id) }
      end
    end

    def send_email
      review = Review.find params[:review_id]
      reviewer = @review.user

      email = reviewer.email
      guest_name = params[:name]
      guest_email = params[:email]
      content = params[:message]
      if UserMailer.send_contact_message(email,guest_name,guest_email,content).deliver
        flash[:success] = "Thanks for your message!"
        redirect_to contact_us_pathEMAIL_CONTACT_US
      else
        flash[:notice] = "Oops, please try again"
        @page = BasicsPage.find(2)
        render :contact_us
      end

      respond_to do |format|
        format.json do
          render json { head :ok }
        end
      end
    end

    private

      def comment_params
        params.require(:comment).permit(:user_id, :content)
      end
  end

end

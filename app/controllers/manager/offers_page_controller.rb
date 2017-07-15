module Manager

  class OffersPageController < ManagerController
    def index
      @offers = current_restaurant.offers
      @new_offer = Offer.new
    end

    def create
      @restaurant =  Restaurant.find(params[:restaurant_id])
      params[:offer].delete 'id'
      params[:offer][:time_start_offer] = params[:offer][:time_start_offer].to_date

      if params[:offer][:is_onetime]
        params[:offer].delete 'start_date'
        params[:offer].delete 'end_date'
      end

      @offer = @restaurant.offers.build(params[:offer])
      respond_to do |format|
        if @offer.save!
          format.html { redirect_to manager_offers_path(@restaurant.id), notice: I18n.t('offer.create_success') }
        end
      end
    end

    def remove
      if Offer.exists? params[:offer_id]
        offer = Offer.find params[:offer_id]
        offer.delete

        respond_to do |format|
          format.json { render json: { success: true } }
          format.html { render :index }
        end
      else
        respond_to do |format|
          format.json { render json: {errors: ["record-not-found"]}}
          format.html { render :index }
        end
      end
    end

    def edit
      @offer = Offer.find params[:offer_id]

      respond_to do |format|
        format.js
      end
    end

    def update
      @offer = Offer.find(params[:offer][:id])
      params[:offer].delete 'id'
      params[:offer][:approve] = false

      if params[:offer][:is_onetime]
        params[:offer].delete 'start_date'
        params[:offer].delete 'end_date'
      end

      respond_to do |format|
        if @offer && @offer.update_attributes(params[:offer])
          format.html { redirect_to manager_offers_path(current_restaurant.id), notice: I18n.t('offer.create_success') }
        end
      end
    end

    private

      def offer_params(params)
        params
      end
  end

end

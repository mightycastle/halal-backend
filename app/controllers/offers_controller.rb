class OffersController < ApplicationController

  layout "admin"
  before_filter :authenticate_user!, :required_user_login, only: [:index, :reject, :approve]
  before_filter :authenticate_user!, :required_admin_role, only: [:index,:approve, :reject]
  before_filter :authenticate_user!, :required_restaurant_owner_role, only: [:create,:update]

  def index
    @search = Offer.search(params[:q])
    @offers = @search.result.order("created_at DESC").page(params[:page])
  end

  def approve
    @offer = Offer.find_by_id(params[:id])
    if @offer.present?
      @offer.update_attributes({approve: true, reject: false})
    end
    respond_to do |format|
      format.js
    end
  end

  def reject
    @offer = Offer.find_by_id(params[:id])
    if @offer.present? && @offer.update_attributes({approve: false, reject: true})
      UserMailer.send_email_for_offer_reject(@offer.restaurant.email_to_contact, @offer.offer_content).deliver
    end
    respond_to do |format|
      format.js
    end
  end

  def update
    respond_to do |format|
      if @offer.save!
        format.html { redirect_to offer_restaurant_path(@offer.restaurant.slug), notice: I18n.t('offer.create_success') }
      else
        format.html { render action: "show" }
      end
    end
  end

  def create
    if params[:offer][:id].present?
      @offer = Offer.find(params[:offer][:id])
      params[:offer].delete 'id'
      params[:offer].delete 'offer_content_new'
      params[:offer][:approve] = false
      params[:offer][:time_available] = '' if params[:offer][:time_available].blank?
      respond_to do |format|
        if @offer && @offer.update_attributes(params[:offer])
          format.html { redirect_to offer_restaurant_path(@offer.restaurant.slug), notice: I18n.t('offer.create_success') }
        end
      end
    else
      @restaurant =  Restaurant.find(params[:rest_id])
      params[:offer].delete 'id'
      params[:offer][:offer_content] = params[:offer_content_new]
      @offer = @restaurant.offers.build(params[:offer])
      respond_to do |format|
        if @offer.save!
          format.html { redirect_to offer_restaurant_path(@restaurant.slug), notice: I18n.t('offer.create_success') }
        end
      end
    end
    
  end

  def get_offer
    @offer =  Offer.find_by_id(params[:id])
    render :json => @offer
  end

  def get_offer_image
    offer =  Offer.find_by_id(params[:id])
    @image = nil
    if offer && offer.image
      @image = offer.image.url
    end
    render :json => {"image" => @image}
  end

  def remove_offer_image
    offer =  Offer.find(params[:id])
    if offer && offer.image
      offer.image = nil
      offer.save
    end
    render :json => true
  end

end

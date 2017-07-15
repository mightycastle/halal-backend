class GiftcardsController < ApplicationController

	helper_method :allowed_giftcard_code_chars
	helper_method :allowed_giftcard_code_length
	
	before_filter :required_user_login
	before_filter :required_restaurant_owner_role
	before_filter :is_restaurant_supporting_giftcards

  # GET
  def manage
    @redemptions = Hash.new
		
		current_user.restaurants.each do |r|
			@redemptions[r.id] = GiftcardRedemption.where restaurant_id: r.id
		end
		
		@redemptions_sorted = GiftcardRedemption.all.select { |gr| gr.restaurant.user_id == current_user.id }
		@redemptions_sorted.sort_by { |gr| gr.created_at }
  end
	
  # POST
  def redeem
		code = params["giftcard_code"]
		restaurant_id = params["restaurant_id"].to_i
		
		restaurant = Restaurant.find restaurant_id
		
		# Can only add giftcards to giftcard restaurants
		if !restaurant.is_giftcard_restaurant?
			render json: {
					status: "ok",
					has_error: "yes",
					error: "unknown_error"
				}
		end
		
		# Check if giftcard with same code exists
		gc = Giftcard.where code: code
		if gc.length == 0
			render json: {
					status: "ok",
					has_error: "yes",
					error: "giftcard_does_not_exist_error"
				}
			return
		end
		gc = gc[0]
		
		if gc.giftcardRedemptions.length != 0
			render json: {
					status: "ok",
					has_error: "yes",
					error: "code_already_redeemed_error"
				}
			return
		end
		
		# Check if length is ok
		if code.length != allowed_giftcard_code_length()
			render json: {
					status: "ok",
					has_error: "yes",
					error: "wrong_length_error"
				}
			return
		end
		
		# Check if format is ok
		code.each_char do |c|
			if allowed_giftcard_code_chars().index(c) == nil
				render json: {
						status: "ok",
						has_error: "yes",
						error: "wrong_format_error"
					}
				return
			end
		end
	
		# Code is valid
		
		gcr = GiftcardRedemption.new
		gcr.restaurant_id = restaurant_id
		gcr.giftcard_id = gc.id
		
		if gcr.save
			render json: {
					status: "ok",
					has_error: "no",
					restaurant_name: gcr.restaurant.name,
					giftcard_value: (gcr.giftcard.pounds + gcr.giftcard.pence/100.0).round(2).to_s
				}
		else
			render json: {
					status: "ok",
					has_error: "yes",
					error: "unknown_error"
				}
		end
  end
	
	def delete
		gc = Giftcard.where code: params[:code]
		
		if gc.length == 0
			render json: {
					status: "ok",
					has_error: "yes",
					error: "giftcard_does_not_exist_error"
				}
			return
		end
		
		if gc.first.giftcardRedemptions.length == 0
			render json: {
					status: "ok",
					has_error: "yes",
					error: "unknown_error"
				}
			return
		end
	
		gcr = gc.first.giftcardRedemptions.first
		puts "#####"
		puts gcr
		gcr.destroy
		
		if gcr.destroyed?
			render json: {
					status: "ok",
					has_error: "no"
				}
		else
			render json: {
					status: "ok",
					has_error: "yes",
					error: "unknown_error"
				}
		end
	end
	
	private
		
		def allowed_giftcard_code_chars()
			"0123456789"
		end
		
		def allowed_giftcard_code_length()
			16
		end
		
		def is_restaurant_supporting_giftcards()
			if !current_user.has_giftcard_restaurant?
				redirect_to root_path
			end
		end
end

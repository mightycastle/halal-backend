require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")


describe RestaurantsController, "test" do
  context "create review action" do
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @params_review = {
        content: "Great restaurant",
        service: 5,
        quality: 5,
        value: 5,
        rating: 5,
        restaurant_id: @restaurant.id
      }
    end

    # it "case 1: Not login, go to page sign in set session, after sign in should create review automatically, go back create new review success" do       
    #   puts "================================="
    #   # puts restaurant_info_path(@restaurant.slug)
    #   # visit restaurant_info_path(@restaurant.slug)
    #   puts @restaurant.to_json
    #   expect{visit "/#{@restaurant.id}"}.to raise_error( ActionController::RoutingError)
      
    #   puts page.body
    #   # fill_in "review[content]", :with => @params_review["content"]
    #   fill_in "review_content", :with => @params_review["content"]
      
    #   fill_in "review[service]", :with => @params_review["service"]
    #   fill_in "review[quality]", :with => @params_review["title"]
    #   fill_in "review[value]", :with => @params_review["title"]
    #   fill_in "review[restaurant_id]", :with => @restaurant.id
    #   fill_in "date[month]", :with => 10
    #   fill_in "date[year]", :with => 2014
    #   click_button "button"

    #   response.should redirect_to(new_user_session_path)
    # end

    it "case 1: Not login, call action should redirect to page sign in" do
      post "create_review", review: @params_review, id: @restaurant.id, date: {year: 2014, month: 10}
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: Login, call action should be success" do
      sign_in @user2
      post "create_review", review: @params_review, id: @restaurant.id, date: {year: 2014, month: 10}
      response.should redirect_to(restaurant_info_path(@restaurant.slug))
      expect(flash[:notice]).to eq I18n.t('review.create_success')
      expect(Review.where(restaurant_id: @restaurant.id, user_id: @user2.id).count).to eq 1
      expect(assigns[:review].content).to eq @params_review[:content]
      expect(assigns[:review].service).to eq @params_review[:service]
      expect(assigns[:review].quality).to eq @params_review[:quality]
      expect(assigns[:review].value).to eq @params_review[:value]
      expect(assigns[:review].status).to eq nil
    end

    it "case 3: Login, call action with missing quality should be error" do
      sign_in @user2
      @params_review["quality"] = nil
      post "create_review", review: @params_review, id: @restaurant.id, date: {year: 2014, month: 10}
      response.should redirect_to(restaurant_info_path(@restaurant.slug))
      expect(Review.where(restaurant_id: @restaurant.id, user_id: @user2.id).count).to eq 0
      expect(flash[:error_rating]).to eq I18n.t("review.missing_rating")
    end

    it "case 4: Login, call action with missing content should be error" do
      sign_in @user2
      @params_review["content"] = nil
      post "create_review", review: @params_review, id: @restaurant.id, date: {year: 2014, month: 10}
      response.should redirect_to(restaurant_info_path(@restaurant.slug))
      expect(Review.where(restaurant_id: @restaurant.id, user_id: @user2.id).count).to eq 1
      expect(flash[:error_content]).to eq I18n.t("review.missing_content")
    end
    

  end
end
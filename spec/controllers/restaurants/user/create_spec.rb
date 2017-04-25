require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")


describe RestaurantsController, "test" do
  context "Create action" do
    before :each do
      clear_database
      @restaurant_hash_params = {
        name: "#{Faker::Name.name}", slug: "#{Faker::Name.name}#{Time.now.to_i}".parameterize,
        phone: '123456789', email: Faker::Internet.email
      }
    end
    it "case 2: with valid params should redirect to root_path" do
      post "create", restaurant: @restaurant_hash_params
      expect(assigns[:restaurant].errors.count).to eq 0      
      response.should redirect_to(root_path)
    end   

    it "case 3: with valid params include review params with user logged" do
      user = create(:user)
      sign_in user
      @restaurant_hash_params[:reviews_attributes] = {"0" => {
          service: 5, quality: 5, value: 5
        }}
      post "create", restaurant: @restaurant_hash_params, check_user: false, date_month: 10, date_year: 2014
      expect(assigns[:restaurant].errors.count).to eq 0
      expect(assigns[:restaurant].reviews.count).to eq 1
      response.should redirect_to(root_path)
    end 

    it "case 4: with valid params include review params without user logged should redirect to root_path" do
      @restaurant_hash_params[:reviews_attributes] = {"0" => {
          service: 5, quality: 5, value: 5
        }}
      post "create", restaurant: @restaurant_hash_params, check_user: false, date_month: 10, date_year: 2014
      expect(assigns[:restaurant].errors.count).to eq 0
      expect(assigns[:restaurant].reviews.count).to eq 0
      expect(session[:review]).not_to be_nil
      response.should redirect_to(root_path)
    end 

    it "case 5: with valid params include review params without logged should redirect to root_path. After loggin -> create review" do
      @restaurant_hash_params[:reviews_attributes] = {"0" => {
          service: 5, quality: 5, value: 5
        }}
      post "create", restaurant: @restaurant_hash_params, check_user: false, date_month: 10, date_year: 2014
      expect(assigns[:restaurant].errors.count).to eq 0
      expect(assigns[:restaurant].reviews.count).to eq 0
      response.should redirect_to(root_path)
      user = create(:user)
      expect(Restaurant.last.reviews.count).to eq 0
    end     

    it "case 6: with valid params include review params by owner info " do
      user = create(:user)      
      sign_in user
      @restaurant_hash_params[:suggester_name] = "abc"
      @restaurant_hash_params[:suggester_email] = "abc@gmail.com"
      @restaurant_hash_params[:suggester_phone] = "abc"
      @restaurant_hash_params[:website] = "google.com"

      @restaurant_hash_params[:reviews_attributes] = {"0" => {
          service: 5, quality: 5, value: 5
        }}
      post "create", restaurant: @restaurant_hash_params, check_user: true, date_month: 10, date_year: 2014
      expect(assigns[:restaurant].errors.count).to eq 0
      expect(assigns[:restaurant].reviews.count).to eq 1
      response.should redirect_to(root_path)
    end   
  end
end
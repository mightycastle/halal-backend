require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")

describe RestaurantsController, "test" do
  

  context "Manage action" do
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      @restaurant = create(:restaurant, {user_id: @user1.id})

      filter_ids = [Filter.find_by_name("Lenanese").id, Filter.find_by_name("Vietnamese").id]
      filter_shisha = FilterType.find_by_name("Shisha").filters.first.id
      filter_price = FilterType.find_by_name("Price").filters.first.id
      @params_update = {"disabled"=>"false",
                        "name"=>"rest 1","phone"=>"0909090090", 
                        "email"=>"rest1@gmail.com", "website"=>"",                         
                        "description"=>"", 
                        "direction"=>"", 
                        "address"=>"222 nguyen van cu", "short_address"=>"", 
                        "district"=>"", "city"=>"hcm", 
                        "postcode"=>"", "country"=>"", 
                        "lat"=>"10.7969409664976", "lng"=>"106.6462129688949", 
                        "filter_ids"=> filter_ids, 
                        "halal_status"=>"", 
                        "filter_id_shisha"=>filter_shisha, "filter_id_price"=>filter_price, 
                        "schedules_attributes"=>{
                          "0"=>{"day_of_week"=>"1", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"1"}, 
                          "3"=>{"day_of_week"=>"2", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"2"}, 
                          "5"=>{"day_of_week"=>"3", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"3"}, 
                          "6"=>{"day_of_week"=>"4", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"4"}, 
                          "8"=>{"day_of_week"=>"5", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"5"}, 
                          "10"=>{"day_of_week"=>"6", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"6"}, 
                          "12"=>{"day_of_week"=>"7", "time_open"=>"600", 
                                 "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"7"}, 
                          "15"=>{"day_of_week"=>"1", "time_open"=>"1700", 
                                 "schedule_type"=>"evening", "time_closed"=>"2300", "id"=>"8"}, 
                          "16"=>{"day_of_week"=>"2", "time_open"=>"1700", 
                                 "schedule_type"=>"evening", "time_closed"=>"2300", "id"=>"9"}, 
                          "18"=>{"day_of_week"=>"3", "time_open"=>"1700", 
                                "schedule_type"=>"evening", "time_closed"=>"2300", "id"=>"10"}, 
                          "21"=>{"day_of_week"=>"4", "time_open"=>"1800", 
                               "schedule_type"=>"evening", "time_closed"=>"2300", "id"=>"11"}, 
                          "23"=>{"day_of_week"=>"5", "time_open"=>"1730", 
                                "schedule_type"=>"evening", "time_closed"=>"2300", "id"=>"12"}, 
                          "25"=>{"day_of_week"=>"6", "time_open"=>"1700", 
                                 "schedule_type"=>"evening", "time_closed"=>"1900", "id"=>"13"}, 
                          "27"=>{"day_of_week"=>"7", "time_open"=>"1700", 
                                 "schedule_type"=>"evening", "time_closed"=>"1900", "id"=>"14"}
                        }
                      }
    end

    it "case 1: not login" do
      put "restaurant_managerment", id: @restaurant.id, restaurant: @params_update
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login, not owner" do
      sign_in @user2
      put "restaurant_managerment", id: @restaurant.id, restaurant: @params_update
      response.should redirect_to("/")
    end    

    it "case 3: login, owner" do
      sign_in @user1
      put "restaurant_managerment", id: @restaurant.id, restaurant: @params_update
      
      expect(flash[:notice]).to eq I18n.t('restaurant.update_wait_approve')
      expect(assigns[:restaurant_temp].restaurant_id).to eq @restaurant.id
      expect(assigns[:restaurant_temp].schedules.count).to eq 14
      expect(assigns[:restaurant_temp].disabled.to_s).to eq @params_update["disabled"]
      expect(assigns[:restaurant_temp].name.to_s).to eq @params_update["name"]
      expect(assigns[:restaurant_temp].email.to_s).to eq @params_update["email"]
      expect(assigns[:restaurant_temp].direction.to_s).to eq @params_update["direction"]
      expect(assigns[:restaurant_temp].address.to_s).to eq @params_update["address"]
      expect(assigns[:restaurant_temp].district.to_s).to eq @params_update["district"]
      expect(assigns[:restaurant_temp].postcode.to_s).to eq @params_update["postcode"]
      expect(assigns[:restaurant_temp].lat.to_s).to eq @params_update["lat"]
      expect(assigns[:restaurant_temp].lng.to_s).to eq @params_update["lng"]
      expect(assigns[:restaurant_temp].filter_ids).to eq (@params_update["filter_ids"] << @params_update["filter_id_shisha"] << @params_update["filter_id_price"])
      expect(assigns[:restaurant_temp].halal_status.to_s).to eq @params_update["halal_status"]
      expect(RestaurantTemp.where(restaurant_id: @restaurant.id).count).to eq 1
      response.should redirect_to(edit_user_restaurant_path(@restaurant.slug))

      @params_update["name"] = "name update new 2"
      put "restaurant_managerment", id: @restaurant.id, restaurant: @params_update

      expect(flash[:notice]).to eq I18n.t('restaurant.update_wait_approve')
      expect(assigns[:restaurant_temp].restaurant_id).to eq @restaurant.id
      expect(assigns[:restaurant_temp].schedules.count).to eq 14
      expect(assigns[:restaurant_temp].disabled.to_s).to eq @params_update["disabled"]
      expect(assigns[:restaurant_temp].name.to_s).to eq @params_update["name"]
      expect(assigns[:restaurant_temp].email.to_s).to eq @params_update["email"]
      expect(assigns[:restaurant_temp].direction.to_s).to eq @params_update["direction"]
      expect(assigns[:restaurant_temp].address.to_s).to eq @params_update["address"]
      expect(assigns[:restaurant_temp].district.to_s).to eq @params_update["district"]
      expect(assigns[:restaurant_temp].postcode.to_s).to eq @params_update["postcode"]
      expect(assigns[:restaurant_temp].lat.to_s).to eq @params_update["lat"]
      expect(assigns[:restaurant_temp].lng.to_s).to eq @params_update["lng"]
      expect(assigns[:restaurant_temp].filter_ids).to eq (@params_update["filter_ids"] )
      expect(assigns[:restaurant_temp].halal_status.to_s).to eq @params_update["halal_status"]
      expect(RestaurantTemp.where(restaurant_id: @restaurant.id).count).to eq 1
      response.should redirect_to(edit_user_restaurant_path(@restaurant.slug))
    end        
  end
end
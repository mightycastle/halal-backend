require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")

describe RestaurantsController, "test" do
  context "Approve change" do
    before :all do
      @user1 = create(:user)
      @admin = create(:user)
      @admin.update_column(:admin_role, true)
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @schedules = create_basic_schedules(@restaurant)
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
      xhr :post, "approve_change", :format => "js", id: @restaurant.slug
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login user" do
      sign_in @user1
      xhr :post, "approve_change", :format => "js", id: @restaurant.slug
      response.should redirect_to(root_path)
    end    

    it "case 3: login, admin" do
      sign_in @user1
      put "restaurant_managerment", id: @restaurant.id, restaurant: @params_update
      sign_out @user1
      sign_in @admin
      expect(@restaurant.schedules.count).to eq 7
      xhr :post, "approve_change", :format => "js", id: @restaurant.slug
      expect(flash[:notice]).to eq I18n.t('restaurant.update_wait_approve')
      expect(assigns[:restaurant].schedules.count).to eq 14
      expect(assigns[:restaurant].disabled.to_s).to eq @params_update["disabled"]
      expect(assigns[:restaurant].name.to_s).to eq @params_update["name"]
      expect(assigns[:restaurant].email.to_s).to eq @params_update["email"]
      expect(assigns[:restaurant].direction.to_s).to eq @params_update["direction"]
      expect(assigns[:restaurant].address.to_s).to eq @params_update["address"]
      expect(assigns[:restaurant].district.to_s).to eq @params_update["district"]
      expect(assigns[:restaurant].postcode.to_s).to eq @params_update["postcode"]
      expect(assigns[:restaurant].lat.to_s).to eq @params_update["lat"]
      expect(assigns[:restaurant].lng.to_s).to eq @params_update["lng"]
      expect(assigns[:restaurant].filter_ids).to eq (@params_update["filter_ids"] << @params_update["filter_id_shisha"] << @params_update["filter_id_price"])
      expect(assigns[:restaurant].halal_status.to_s).to eq @params_update["halal_status"]
      expect(RestaurantTemp.where(restaurant_id: @restaurant.id).count).to eq 0      
    end        
  end
end
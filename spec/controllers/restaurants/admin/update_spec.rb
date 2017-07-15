require 'spec_helper'
require 'rails_helper'
require Rails.root.join("spec/helpers/restaurant_helper.rb")

describe RestaurantsController, "test" do
  

  context "Update action" do
    before :each do
      @admin = create(:user)
      @admin.update_column(:admin_role, true)
      @user1 = create(:user)
      @restaurant = create(:restaurant, {user_id: @user1.id})
      @schedules = create_basic_schedules(@restaurant)
  
      @params_update = {"disabled"=>"false",
                        "name"=>"rest 1","phone"=>"0909090090", 
                        "email"=>"rest1@gmail.com", "website"=>"google.com",                         
                        "description"=>"desc", 
                        "direction"=>"", "slug"=> @restaurant.slug, 
                        "address"=>"222 nguyen van cu", "short_address"=>"", 
                        "district"=>"", "city"=>"hcm", 
                        "postcode"=>"", "country"=>"", 
                        "lat"=>"10.7969409664976", "lng"=>"106.6462129688949", 
                        "filter_ids"=>["23", "10", "18", "19", "20", "25"], 
                        "halal_status"=>"", "filter_id_shisha"=>"13", 
                        "filter_id_price"=>"16", 
                        "schedules_attributes"=>{
                          "0"=>{"day_of_week"=>"1", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"#{@schedules[0].id}"}, 
                          "3"=>{"day_of_week"=>"2", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"#{@schedules[1].id}"}, 
                          "5"=>{"day_of_week"=>"3", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"#{@schedules[2].id}"}, 
                          "6"=>{"day_of_week"=>"4", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"#{@schedules[3].id}"}, 
                          "8"=>{"day_of_week"=>"5", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"#{@schedules[4].id}"}, 
                          "10"=>{"day_of_week"=>"6", "time_open"=>"600", 
                                "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"#{@schedules[5].id}"}, 
                          "12"=>{"day_of_week"=>"7", "time_open"=>"600", 
                                 "schedule_type"=>"daily", "time_closed"=>"1500", "id"=>"#{@schedules[6].id}"}, 
                          "15"=>{"day_of_week"=>"1", "time_open"=>"1700", 
                                 "schedule_type"=>"evening", "time_closed"=>"2300"}, 
                          "16"=>{"day_of_week"=>"2", "time_open"=>"1700", 
                                 "schedule_type"=>"evening", "time_closed"=>"2300"}, 
                          "18"=>{"day_of_week"=>"3", "time_open"=>"1700", 
                                "schedule_type"=>"evening", "time_closed"=>"2300"}, 
                          "21"=>{"day_of_week"=>"4", "time_open"=>"1800", 
                               "schedule_type"=>"evening", "time_closed"=>"2300"}, 
                          "23"=>{"day_of_week"=>"5", "time_open"=>"1730", 
                                "schedule_type"=>"evening", "time_closed"=>"2300"}, 
                          "25"=>{"day_of_week"=>"6", "time_open"=>"1700", 
                                 "schedule_type"=>"evening", "time_closed"=>"1900"}, 
                          "27"=>{"day_of_week"=>"7", "time_open"=>"1700", 
                                 "schedule_type"=>"evening", "time_closed"=>"1900"}
                        }
                      }
    end

    it "case 1: not login" do
      put "update", id: @restaurant.id, restaurant: @params_update, admin: true
      response.should redirect_to(new_user_session_path)
    end

    it "case 2: login, owner" do
      sign_in @user1
      put "update", id: @restaurant.id, restaurant: @params_update, admin: true
      response.should redirect_to(root_path)
    end    

    it "case 3: login, admin" do
      sign_in @admin
      put "update", id: @restaurant.id, restaurant: @params_update, admin: true
      response.should redirect_to(edit_restaurant_path(@restaurant.slug))
      expect(flash[:notice]).to eq I18n.t('restaurant.update_success')
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
      expect(assigns[:restaurant].filter_ids.map{|n| n.to_s}).to eq (@params_update["filter_ids"] << @params_update["filter_id_shisha"] << @params_update["filter_id_price"])
      expect(assigns[:restaurant].halal_status.to_s).to eq @params_update["halal_status"]
    end        
  end
end
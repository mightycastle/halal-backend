#encoding: utf-8
namespace :db do
  task :edit_filter_name_phase3 => :environment do

    # rename for designer --------------------------
    t = Filter.find_by_code("staff_confirmation")
    t.update_column(:name, "Staff confirmed") if t.present?

    t = Filter.find_by_code("bring_your_own")
    t.update_column(:name, "Bring your own") if t.present?

    t = Filter.find_by_code("offer")
    t.update_column(:name, "Offer available") if t.present?

    t = Filter.find_by_code("shisha_allowed")
    t.update_column(:name, "Shisha") if t.present?

    t = Filter.find_by_code("shisha_not_allowed")
    t.update_column(:name, "Shisha not alowed") if t.present?

    t = Filter.find_by_code("delivery_available")
    t.update_column(:name, "Delivery") if t.present?

    t = Filter.find_by_code("wheelchair_accessible")
    t.update_column(:name, "wheelchair access") if t.present?


    # create new FilterType Features, and Filter no_pork
    filter_type_feature = FilterType.where(name: "Features", code: 'features').first_or_create
    Filter.where(code: "no_pork", name: "No pork", description: "No pork" , filter_type_id: filter_type_feature.id).first_or_create


    # group filter type to "Features"
    arr = ["offer", "shisha", "facility", "organic"]
    FilterType.all.each do |filter_type|

      # update filter_type_id for filters
      if arr.include?(filter_type.code)
        filter_type.filters.update_all(filter_type_id: filter_type_feature.id)

        #update FilterTypesRestaurant
        # st = ActiveRecord::Base.connection.raw_connection.prepare("update filter_types_restaurants set filter_type_id=? where filter_type_id=?")
        # st.execute(filter_type.id, filter_type.id)
        connection = ActiveRecord::Base.connection
        query_sql = "UPDATE filter_types_restaurants SET filter_type_id=#{filter_type_feature.id} where filter_type_id=#{filter_type.id}"
        connection.execute(query_sql)
        connection.close
      end
    end


    # set index for filtertype
    FilterType.all.each do |ft|
      case ft.code
      when "hal_status"
        ft.index_order = 1
      when "alcohol"
        ft.index_order = 2    
      when "price"
        ft.index_order = 3            
      when "cuisine"
        ft.index_order = 4
      when "features"
        ft.index_order = 5
      when "open_hour"
        ft.index_order = 6
      when "shisha"
        ft.index_order = 7
      when "facility"
        ft.index_order = 8
      when "offer"
        ft.index_order = 9
      when "organic"
        ft.index_order = 10
      end

      ft.save
    end
  end

  task :edit_price_phase3 => :environment do
    Filter.where("code = 'price'").each do |price|
      price.update_column(:name, "Under £15") if price.name == "£ (Under £10)"
      price.update_column(:name, "£15-30") if price.name == "££ (£10 to £30)"
      price.update_column(:name, "£30-50") if price.name == "£££ (Over £30)"
    end

    ftype = FilterType.find_by_code("price")
    if ftype.present?
      Filter.where(code: 'price', name: 'Over £50', description: '£££', status: 1, filter_type_id: ftype.id).first_or_create
    end
    
  end

  task :index_order_filter_phase3 => :environment do
    Filter.all.each do |ft|
      case ft.code
      when "staff_confirmation"
        ft.index_order = 1
      when "sign_in_window"
        ft.index_order = 2    
      when "certificate"
        ft.index_order = 3  

      when "alcohol_served"
        ft.index_order = 4
      when "bring_your_own"
        ft.index_order = 5
      when "alcohol_not_allowed"
        ft.index_order = 6

      when "price"
        if ft.name == "Under £10"
          ft.index_order = 7
        elsif ft.name == "£10 to £30"
          ft.index_order = 8
        elsif ft.name == "Over £30"
          ft.index_order = 9
        elsif ft.name == "Over £50"
          ft.index_order = 10
        end
          
      when "offer"
        ft.index_order = 11

      when "shisha_allowed"
        ft.index_order = 12
      when "shisha_not_allowed"
        ft.index_order = 13

      when "delivery_available"
        ft.index_order = 14     

      when "wheelchair_accessible"
        ft.index_order = 15     

      when "wifi_available"
        ft.index_order = 16         
        
      when "organic"
        ft.index_order = 17              

      when "no_pork"
        ft.index_order = 18          
      end

      ft.save
    end
  end

  task :fix_code_phase3 => :environment do
    alcohol_available = Filter.where("code = 'available' AND description = 'Alcohol'").first
    alcohol_available.update_attributes(code: "alcohol_served") if alcohol_available.present?

    alcohol_not_allow = Filter.where("code = 'not_allow' AND description = 'Alcohol'").first
    alcohol_not_allow.update_attributes(code: "alcohol_not_allowed") if alcohol_not_allow.present?

    shisha_allow = Filter.where("code = 'available' AND description = 'Available in outdoor area'").first
    shisha_allow.update_attributes(code: "shisha_allowed") if shisha_allow.present?


    shisha_not_allow = Filter.where("code = 'not_allow' AND description = 'Not allowed on premises'").first
    # shisha_not_allow.update_attributes(code: "shisha_not_allowed") if shisha_not_allow.present?
    shisha_not_allow.destroy if shisha_not_allow.present?

    Filter.where(filter_type_id: FilterType.find_by_code('cuisine').id).update_all(code: 'cuisine')
    Filter.where(filter_type_id: FilterType.find_by_code('price').id).update_all(code: 'price')
  end
end
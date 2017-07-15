#encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

a = FilterType.where(name: "Cuisine", code: 'cuisine').first_or_create
c = FilterType.where(name: "Opening hours", code: 'open_hour').first_or_create
d = FilterType.where(name: "Alcohol", code: 'alcohol').first_or_create
e = FilterType.where(name: "Shisha", code: 'shisha').first_or_create
f = FilterType.where(name: "Price", code: 'price').first_or_create
g = FilterType.where(name: "Facilities", code: 'facility').first_or_create
h = FilterType.where(name: "Halal status", code: 'hal_status').first_or_create
l = FilterType.where(name: "Offers", code: 'offer').first_or_create
m = FilterType.where(name: "Organic", code: 'organic').first_or_create

Filter.where(code: "cuisine", name: "Lenanese", description: "Lenanese", filter_type_id: a.id).first_or_create
Filter.where(code: "cuisine", name: "Meze", description: "Meze",filter_type_id: a.id).first_or_create
Filter.where(code: "cuisine", name: "Turkish", description: "Turkish" ,filter_type_id: a.id).first_or_create
Filter.where(code: "cuisine", name: "Maroccan", description: "Maroccan" ,filter_type_id: a.id).first_or_create
Filter.where(code: "cuisine", name: "Italian", description: "Italian" ,filter_type_id: a.id).first_or_create
Filter.where(code: "cuisine", name: "Vietnamese", description: "Vietnamese" ,filter_type_id: a.id).first_or_create
Filter.where(code: "cuisine", name: "Thai", description: "Thailand" ,filter_type_id: a.id).first_or_create
Filter.where(code: "cuisine", name: "Indian", description: "Indian" ,filter_type_id: a.id).first_or_create
Filter.where(code: "open_hour", name: "Open Now", description: "Open Now" ,filter_type_id: c.id).first_or_create

if Filter.where("code = 'available' OR code = 'alcohol_served'").blank?
  if Filter.where(code: "available", name: "Available", description: "Alcohol served here" ,filter_type_id: d.id).present?
    Filter.where(code: "available", name: "Available", description: "Alcohol served here" ,filter_type_id: d.id).first.update_column(:code, "alcohol_served")
  elsif Filter.where(code: "alcohol_served", name: "Available", description: "Alcohol served here" ,filter_type_id: d.id).blank?
    Filter.create(code: "alcohol_served", name: "Available", description: "Alcohol served here" ,filter_type_id: d.id)
  end
end

if Filter.where(code: "bring_your_own").blank?
  Filter.where(code: "bring_your_own", name: "Bring your own bottle", description: "Bring your own bottle" ,filter_type_id: d.id).first_or_create
end

if Filter.where("code = 'not_allow' OR code = 'alcohol_not_allowed'").blank?
  if Filter.where(code: "not_allow", name: "Not allowed", description: "Not allowed on the premises" ,filter_type_id: d.id).present?
    Filter.where(code: "not_allow", name: "Not allowed", description: "Not allowed on the premises" ,filter_type_id: d.id).first.update_column(:code, "alcohol_not_allowed")
  elsif Filter.where(code: "alcohol_not_allowed", name: "Not allowed", description: "Not allowed on the premises" ,filter_type_id: d.id).blank?
    Filter.create(code: "alcohol_not_allowed", name: "Not allowed", description: "Not allowed on the premises" ,filter_type_id: d.id)
  end
end


if Filter.where("code = 'available' OR code = 'shisha_allowed'").blank?
  if Filter.where(code: "available", name: "Available", description: "Available in outdoor area" ,filter_type_id: e.id).present?
    Filter.where(code: "available", name: "Available", description: "Available in outdoor area" ,filter_type_id: e.id).first.update_column(:code, "shisha_allowed")
  elsif Filter.where(code: "shisha_allowed", name: "Available", description: "Available in outdoor area" ,filter_type_id: e.id).blank?
    Filter.create(code: "shisha_allowed", name: "Available", description: "Available in outdoor area" ,filter_type_id: e.id)
  end
end


if Filter.where("code = 'not_allow' OR code = 'shisha_not_allowed'").blank?
  if Filter.where(code: "not_allow", name: "Not allowed", description: "Not allowed on premises" ,filter_type_id: e.id).present?
    Filter.where(code: "not_allow", name: "Not allowed", description: "Not allowed on premises" ,filter_type_id: e.id).first.update_column(:code, "shisha_not_allowed")
  elsif Filter.where(code: "shisha_not_allowed", name: "Not allowed", description: "Not allowed on premises" ,filter_type_id: e.id).blank?
    Filter.create(code: "shisha_not_allowed", name: "Not allowed", description: "Not allowed on premises" ,filter_type_id: e.id)
  end
end

if Filter.where(code: "price", name: "£ (Under £10)").blank? && Filter.where(code: "price", name: "Under £15").blank?
  Filter.where(code: "price", name: "£ (Under £10)", description: "£" ,filter_type_id: f.id).first_or_create
end
if Filter.where(code: "price", name: "££ (£10 to £30)").blank? && Filter.where(code: "price", name: "£15-30").blank?
  Filter.where(code: "price", name: "££ (£10 to £30)", description: "££" ,filter_type_id: f.id).first_or_create
end
if Filter.where(code: "price", name: "£££ (Over £30)").blank? && Filter.where(code: "price", name: "£30-50").blank?
  Filter.where(code: "price", name: "£££ (Over £30)", description: "£££" ,filter_type_id: f.id).first_or_create
end

if Filter.where(code: "wifi_available").blank?
  Filter.where(code: "wifi_available", name: "Wifi available", description: "Wifi Available" ,filter_type_id: g.id).first_or_create
end
if Filter.where(code: "wheelchair_accessible").blank?
  Filter.where(code: "wheelchair_accessible", name: "Wheelchair accessible", description: "Wheelchair Accessible" ,filter_type_id: g.id).first_or_create
end
if Filter.where(code: "delivery_available").blank?
  Filter.where(code: "delivery_available", name: "Delivery available", description: "Delivery available" ,filter_type_id: g.id).first_or_create
end
if Filter.where(code: "staff_confirmation").blank?
  Filter.where(code: "staff_confirmation", name: "Staff confirmation", description: "Staff confirmation" ,filter_type_id: h.id).first_or_create
end
if Filter.where(code: "sign_in_window").blank?
  Filter.where(code: "sign_in_window", name: "Sign in window", description: "Sign in window" ,filter_type_id: h.id).first_or_create
end
if Filter.where(code: "certificate").blank?
  Filter.where(code: "certificate", name: "Certificate available", description: "Certificate available" ,filter_type_id: h.id).first_or_create
end

if Filter.where(code: "offer").blank?
  Filter.where(code: "offer", name: "Restaurant with offers", description: "Restaurant with offers" ,filter_type_id: l.id).first_or_create
end
if Filter.where(code: "organic").blank?
  Filter.where(code: "organic", name: "Organic Available", description: "Organic available" , filter_type_id: m.id).first_or_create
end


FilterType.all.each do |ft|
  case ft.code
  when "cuisine"
    ft.index_order = 4
  when "open_hour"
    ft.index_order = 6
  when "alcohol"
    ft.index_order = 2
  when "shisha"
    ft.index_order = 5
  when "price"
    ft.index_order = 3
  when "facility"
    ft.index_order = 5
  when "hal_status"
    ft.index_order = 1
  when "offer"
    ft.index_order = 5
  when "organic"
    ft.index_order = 5
  end
    ft.save
end

BasicsPage.find_or_create_by_page_name("About us")
BasicsPage.find_or_create_by_page_name("Contact us")
BasicsPage.find_or_create_by_page_name("How it works")
BasicsPage.find_or_create_by_page_name("FAQ's")
BasicsPage.find_or_create_by_page_name("Terms & Conditions")
BasicsPage.find_or_create_by_page_name("Footer")

#create admin user
user = User.find_by_email("admin@nexlesoft.com")
if user.blank?
  user = User.new
  user.username = "admin"
  user.email = "admin@nexlesoft.com"
  user.password = "123456"
  user.admin_role = true
  user.confirmation_token = nil
  user.username = 'adminnexle'
  user.first_name = 'Admin'
  user.last_name = 'Nexle'
  user.status = 'verified'
  user.save!
end

p1 = PlanType.where(name: "Annual", number_of_months: 12).first_or_create
p2 = PlanType.where(name: "Monthly", number_of_months: 1).first_or_create
    

Plan.where(name: "Annual", amount: "20", plan_type_id: p1.id, description: 'When you sign up for 1 year').first_or_create
Plan.where(name: "Monthly", amount: "30", plan_type_id: p2.id, description: 'Lorem ipsum').first_or_create



# f = Filter.where(code: 'card_accepted').first

# rests = f.restaurants
# rests.each do |r|
#   f_r = r.filter_ids
#   f_r.delete(f.id)
#   r.filter_ids = f_r
# end
# f.delete




# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160117060649) do

  create_table "admin_photos", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "cover",          :default => false
    t.string   "image_uid"
    t.string   "image_name"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "image_type",     :default => true
    t.string   "text_title"
    t.text     "text_content"
    t.string   "text_hyperlink"
  end

  create_table "basics_pages", :force => true do |t|
    t.string   "page_name"
    t.text     "page_content"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "page_uid"
  end

  create_table "checkins", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "collection_images", :force => true do |t|
    t.integer  "collection_id"
    t.string   "image_uid"
    t.string   "image_name"
    t.string   "text_hyperlink"
    t.string   "text_title"
    t.text     "text_content"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "collection_restaurants", :force => true do |t|
    t.integer "collection_id"
    t.integer "restaurant_id"
    t.integer "order"
  end

  create_table "collections", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "disabled"
  end

  create_table "favourites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "filter_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "code"
    t.integer  "index_order"
  end

  create_table "filter_types_restaurants", :id => false, :force => true do |t|
    t.integer  "filter_type_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "filters", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.boolean  "status",         :default => true
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "filter_type_id"
    t.integer  "index_order",    :default => 99
  end

  create_table "filters_restaurant_temps", :id => false, :force => true do |t|
    t.integer  "filter_id"
    t.integer  "restaurant_temp_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "filters_restaurants", :id => false, :force => true do |t|
    t.integer  "filter_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "giftcard_redemptions", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "giftcard_id"
    t.integer  "pounds"
    t.integer  "pence"
    t.boolean  "deleted"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "giftcard_restaurant_memberships", :force => true do |t|
    t.integer "restaurant_id"
  end

  create_table "giftcards", :force => true do |t|
    t.string   "code"
    t.integer  "pounds"
    t.integer  "pence"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "menus", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.string   "menu_uid"
    t.string   "menu_name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
  end

  create_table "offers", :force => true do |t|
    t.text     "offer_content"
    t.integer  "restaurant_id"
    t.string   "time_available"
    t.string   "time_start_offer"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "start_time"
    t.integer  "end_time"
    t.string   "date_publish"
    t.integer  "time_publish"
    t.integer  "start_date"
    t.integer  "end_date"
    t.boolean  "approve",          :default => false
    t.boolean  "reject",           :default => false
    t.string   "image_uid"
    t.string   "image_name"
    t.boolean  "is_onetime",       :default => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "user_id"
    t.boolean  "cover",              :default => false
    t.string   "image_uid"
    t.string   "image_name"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "restaurant_temp_id"
    t.string   "text_title"
    t.text     "text_content"
    t.string   "text_hyperlink"
    t.integer  "status",             :default => 0
  end

  create_table "plan_types", :force => true do |t|
    t.string   "name"
    t.integer  "number_of_months"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.integer  "amount"
    t.integer  "plan_type_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "description"
  end

  create_table "restaurant_temps", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.text     "description"
    t.string   "phone"
    t.string   "email"
    t.integer  "user_id"
    t.boolean  "deliverable"
    t.boolean  "shisha_allow"
    t.boolean  "disabled",                                        :default => false
    t.decimal  "price",           :precision => 10, :scale => 0,  :default => 0
    t.string   "website"
    t.text     "halal_status"
    t.text     "special_deal"
    t.decimal  "lat",             :precision => 16, :scale => 13
    t.decimal  "lng",             :precision => 16, :scale => 13
    t.string   "district"
    t.string   "city"
    t.string   "postcode"
    t.string   "country"
    t.string   "short_address"
    t.string   "contact_note"
    t.string   "suggester_name"
    t.boolean  "is_owner"
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.string   "pinterest_link"
    t.integer  "restaurant_id"
    t.string   "slug"
    t.string   "direction"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.string   "suggester_email"
    t.string   "suggester_phone"
    t.string   "instagram_link"
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.text     "description"
    t.string   "phone"
    t.string   "email"
    t.integer  "user_id"
    t.boolean  "deliverable"
    t.boolean  "shisha_allow"
    t.boolean  "disabled"
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
    t.decimal  "lat",                        :precision => 16, :scale => 13
    t.decimal  "lng",                        :precision => 16, :scale => 13
    t.string   "district"
    t.string   "city"
    t.string   "postcode"
    t.string   "country"
    t.text     "direction"
    t.float    "service_avg",                                                :default => 0.0
    t.float    "quality_avg",                                                :default => 0.0
    t.float    "value_avg",                                                  :default => 0.0
    t.float    "rating_avg",                                                 :default => 0.0
    t.decimal  "price",                      :precision => 10, :scale => 0,  :default => 0
    t.string   "menu_uid"
    t.string   "menu_name"
    t.boolean  "is_owner"
    t.string   "contact_note"
    t.string   "suggester_name"
    t.string   "website"
    t.text     "halal_status"
    t.string   "short_address"
    t.string   "slug"
    t.text     "special_deal"
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.string   "pinterest_link"
    t.boolean  "waiting_for_approve_change",                                 :default => false
    t.string   "suggester_email"
    t.string   "suggester_phone"
    t.boolean  "request_approve_photo",                                      :default => false
    t.string   "instagram_link"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.string   "title"
    t.text     "content"
    t.integer  "service"
    t.integer  "quality"
    t.integer  "value"
    t.boolean  "status"
    t.float    "rating"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.date     "visited_date"
    t.boolean  "terms_conditions"
    t.boolean  "feature_review",        :default => false
    t.date     "feature_review_set_at"
    t.text     "reply_content"
    t.integer  "user_reply"
    t.boolean  "approve_reply"
    t.datetime "reply_time"
    t.boolean  "satisfied"
    t.boolean  "owner_has_read",        :default => false
  end

  create_table "schedules", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "day_of_week"
    t.integer  "time_open"
    t.integer  "time_closed"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "restaurant_temp_id"
    t.string   "schedule_type",      :default => "daily"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "card_number"
    t.integer  "card_verification"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.integer  "plan_id"
    t.datetime "expire_time"
    t.boolean  "recurring_status",  :default => true
    t.string   "account_id"
    t.string   "transaction_id"
    t.string   "profile_id"
    t.integer  "paypal_status"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "subscription_id"
    t.string   "transaction_id"
    t.text     "transaction_data"
    t.string   "amount"
    t.datetime "next_billing_cycle"
    t.integer  "transaction_status"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                    :default => "",           :null => false
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "phone"
    t.string   "address"
    t.string   "im"
    t.string   "status",                   :default => "unverified"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "encrypted_password",       :default => "",           :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",          :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.boolean  "admin_role"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.boolean  "join_mailing_list"
    t.string   "avatar_uid"
    t.string   "avatar_name"
    t.boolean  "is_subscribed",            :default => true
    t.boolean  "restaurant_owner_role",    :default => false
    t.string   "postcode"
    t.boolean  "gem_hunter",               :default => false
    t.string   "device_token"
    t.integer  "device_type"
    t.string   "fb_access_token"
    t.string   "avatar_fb_url"
    t.string   "gem_hunter_wordpress_url"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end

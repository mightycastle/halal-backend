Halalgems::Application.routes.draw do

  namespace :manager do
    get ':restaurant_id', to: 'dashboard_page#index', as: 'restaurant_root'

    get ':restaurant_id/dashboard', to: 'dashboard_page#index', as: 'dashboard'
    get '/:restaurant_id/statistics', to: 'statistics_page#index', as: 'statistics'

    get '/:restaurant_id/reviews', to: 'reviews_page#index', as: 'reviews'
    get '/:restaurant_id/reviews/:review_id', to: 'reviews_page#show_review'
    post '/:restaurant_id/reviews/:review_id/email', to: 'reviews_page#send_email', as: 'send_email'
    get '/:restaurant_id/reviews/:review_id/comment', to: 'reviews_page#post_comment', as: 'post_comment'


    get '/:restaurant_id/restaurant-info', to: 'restaurant_info_page#index', as: 'restaurant_info'
    get '/:restaurant_id/restaurant-info/edit', to: 'restaurant_info_page#edit', as: 'restaurant_info_edit'
    put '/:restaurant_id/restaurant-info', to: 'restaurant_info_page#update'

    get '/:restaurant_id/offers-and-deals', to: 'offers_page#index', as: 'offers'
    post '/:restaurant_id/offers-and-deals/create', to: 'offers_page#create', as: 'offers_create'
    get '/:restaurant_id/offers-and-deals/edit', to: 'offers_page#edit', as: 'offers_edit'
    post '/:restaurant_id/offers-and-deals/update', to: 'offers_page#update', as: 'offers_update'
    post '/:restaurant_id/offers-and-deals/remove', to: 'offers_page#remove', as: 'offers_remove'

    get '/:restaurant_id/pull_data', to: 'manager#pull_data', as: 'pull_data'
  end

  get 'giftcards', to: 'giftcards#manage'
  post 'giftcards', to: 'giftcards#redeem'
	delete 'giftcards', to: 'giftcards#delete'

  post 'paypal/notify'
  # Mount Grape API
  mount API => '/'
  # resources :plan_types

  resources :plans, :only => [:index]

  resources :subscriptions, :only => [:new, :create, :index] do
    collection do
      get 'express'
    end
    member do
      post 'cancel_curring'
      post 'renew_curring'
    end
  end
  get '/become_a_member' => 'subscriptions#index'
  # resources :reply_reviews

  mount Ckeditor::Engine => '/ckeditor'
  get 'basics_pages/index'

#  get 'user_restaurants/index'
#  get 'user_restaurants/new'
#  get 'user_restaurants/create'
#  get 'user_restaurants/show'
#  get 'user_restaurants/destroy'
  #build json service
  match 'api_login'                           => 'services#login' , :via => :post
  match 'api_login_with_facebook'             => 'services#login_with_facebook' , :via => :post
  match 'api_signup'                          => 'services#signup'
  match 'api_signout'                         => 'services#destroy', :via => :delete
  match 'api_reset_password'                  => 'services#reset_password'
  match 'api_restaurant_detail'               => 'services#restaurant_detail'
  match 'api_download_menu'                   => 'services#download_menu'

  match 'api_search_restaurant'               => 'services#search_restaurant'
  match 'api_search_restaurant_by_name'       => 'services#search_restaurant_by_name'

  match 'api_add_restaurant'                  => 'services#add_restaurant'
  match 'api_add_review'                      => 'services#add_review'
  match 'api_get_restaurant_list_by_location' => 'services#get_restaurant_list_by_location'
  match 'api_get_review_list'                 => 'services#get_review_list'
  match 'api_get_favourite_list'              => 'services#get_favourite_list'
  match 'api_about_us'                        => 'services#about_us'
  match 'api_contact_us'                      => 'services#contact_us'
  match 'api_faq'                             => 'services#faq'
  match 'api_faq_simple'                      => 'services#faq'
  match 'api_how_it_works'                    => 'services#how_it_works'
  match 'api_terms_conditions'                => 'services#terms_conditions'
  match 'api_personal_information'            => 'services#personal_information'
  match 'api_cuisine_list'                    => 'services#cuisine_list'
  match 'api_all_filters'                     => 'services#all_filters'
  match 'api_add_to_favourite_list'           => 'services#add_to_favourite_list'
  match 'api_remove_to_favourite_list'        => 'services#remove_to_favourite_list'

  match 'pages/add_email_landing'             => 'pages#add_email_landing'


  match 'my_favourite'                        => 'user_restaurants#my_favourite'
# match '/my_reviews'                         => 'reviews#my_reviews'


  get '/download_menu'                        => 'pages#download_menu', as: 'download_menu'
  resources :admin_photos
  match '/admin/upload_photos'                => 'admin_photos#admin_upload_photos'
  match '/change_image_type'                  => 'admin_photos#change_image_type'

  match 'search/by_location'
# get '/admin'                                => redirect('/admin/restaurants')
  get '/admin'                                => 'restaurants#index'
  get '/home'                                 => 'pages#home'


  get '/personal_information'                 => 'pages#personal_information', as: 'personal_information'
  get '/my_purchases'                         => 'pages#my_purchases', as: 'my_purchases'
  post '/update_personal_information'         => 'pages#update_personal_information', as: 'update_personal_information'
  get '/about_us'                             => 'pages#about_us'
  match '/refresh_captcha'                    => 'pages#refresh_captcha'
  get '/faq'                                  => 'pages#faq'
  get '/faq_simple'                           => 'pages#faq_simple'
  get '/how_it_works'                         => 'pages#how_it_works'

  get '/contact_us'                           => 'pages#contact_us'
  post '/send_contact_message'                => 'pages#send_contact_message'
  get '/registered'                           => 'pages#registered', as: 'registered'
  get '/terms_conditions'                     => 'pages#terms_conditions', as: 'terms_conditions'
  match '/show_reviews'                       => 'pages#show_reviews', as: 'show_reviews'
  match '/show_reviews_sorted'                => 'pages#show_reviews_sorted', as: 'show_reviews_sorted'
  post '/newsletter'                          => 'pages#newsletter', as: 'newsletter'

  post 'send_direction'                       => 'pages#send_direction', as: 'send_direction'

  get '/advertise_your_restaurant'            => 'pages#advertise_your_restaurant'
  post '/send_advertise_restaurant_message'   => 'pages#send_advertise_restaurant_message'

  post '/user_restaurants/reply_review'       => 'reviews#reply_review'
  get '/offer/:id/get_offer'                  => 'offers#get_offer'
  get '/offer/:id/get_offer_image'            => 'offers#get_offer_image'
  post '/offer/:id/remove_offer_image'        => 'offers#remove_offer_image'


  #resources :reviews
  resources :reviews, except: [:new] do
    member do
      post :rate
      post :update_reply_content
      post :update_review
    end
    collection do
    end
  end

  devise_for :users , :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' ,
           :registrations => 'registrations',
           :confirmations=>'confirmations', :sessions => 'sessions'
  }
  devise_for :users, :skip => [:registrations]
    as :user do
      get 'users/change_password' => 'registrations#change_password', :as => 'change_password_user_registration'
      put 'users/update_password' => 'registrations#update_password', :as => 'user_registration_update_password'
    end
  resources :photos, :only => [:index, :create, :destroy] do
    member do
      post 'approve'
      post 'reject'
      post 'to_cover'
    end
  end
  resources :users do

    collection do
      get :check_user
      post :send_email_restaurant_owner
      post :share_restaurant_via_email
    end
    member do
      post 'update_avatar' => 'users#update_avatar' , as: 'update_avatar'
    end
  end
  resources :user_restaurants
  resources :restaurants do
    member do
      # put  'update_social_link'  => 'restaurants#update_social_link',  as: 'update_social_link'
      # post 'add_favourite'       => 'restaurants#add_favourite',       as: 'add_favourite'
      # post 'remove_favourite'    => 'restaurants#remove_favourite',    as: 'remove_favourite'
      # post 'remove_my_favourite' => 'restaurants#remove_my_favourite', as: 'remove_my_favourite'
      # get  'offer'               => 'restaurants#offer',               as: 'offer'
      # get  'offer/:offer_id'     => 'restaurants#offer'
      # post 'create_offer'        => 'restaurants#create_offer',        as: 'create_offer'
      # put  'update_offer'        => 'restaurants#update_offer',        as: 'update_offer'
      # post 'create_review'       => 'restaurants#create_review',       as: 'create_review'
      # get  'report'              => 'restaurants#show'
      # post 'report'              => 'restaurants#report'
    end
  end
  resources :offers do
    member do
      post :approve
      post :reject
    end
  end
  scope '/admin' do
    get  'collections'             => 'collections#index'
    get  'change_photo_request'    => 'restaurants#change_photo_request'
    resources :users, :except => [:destroy, :new, :create] do
      member do
        post 'change_status/:status' => 'users#change_status', as: 'change_status'
        post 'toggle_gem_hunter/:status' => 'users#toggle_gem_hunter', as: 'toggle_gem_hunter'
      end
    end
    resources :restaurants do
      get :autocomplete_user_username, :on => :collection
      get :autocomplete_restaurant_name, :on => :collection
      collection do
        put 'restaurant_managerment'
        # get 'index' => 'restaurants#index'
        get 'admin_new' => 'restaurants#admin_new', as: 'new_restaurant'
      end
      member do
        post 'disable_toggle'
        post 'add_favourite'
        get 'remove_favourite'
        post 'create_user_restaurant'
        post 'approve_change'
        post 'reject_change'
      end
    end
    resources :collections do
      collection do
        get 'admin_new_collection' => 'collections#admin_new_collection', as: 'new_collection'
        post 'destroy/:id' => 'collections#destroy', as: 'destroy_collection'
        post 'add_restaurant/:id' => 'collections#add_restaurant', as: 'add_restaurant'
      end
      member do
        post 'disable_toggle'
        post 'remove_restaurant/:restaurant_id' => 'collections#remove_restaurant', as: 'remove_restaurant'
      end
    end
    resources :restaurant_waiting_approves
    resources :reviews, except: [:new] do
      member do
        post 'change_status/:status' => 'reviews#change_status', as: 'change_status'
        post 'change_approve_reply/:approve_reply' => 'reviews#change_approve_reply', as: 'change_approve_reply'
        post 'set_featured/:status' => 'reviews#set_featured' , as: 'set_featured'
      end
    end
    resources :filters do
      member do
        post 'change_status/:status' => 'filters#change_status', as: 'change_status'
        post :update_name
      end
    end
    resources :basics_pages
    resources :filter_types
    resources :menus
    resources :photos do
      member do
        put 'update_text_photo/:type' => 'photos#update_text_photo' , as: 'update_text'
      end
    end
    resources :offers

  end



  namespace :admin do
    resources :users, :restaurants, :collections, :filters, :photos, :basics_pages, :restaurant_waiting_approves, :reviews, :offers
  end
  get '/admin/admin_review_replies' => 'reviews#admin_review_replies', as: 'reply_admin_review'
  get '/admin/admin_subscriptions' => 'subscriptions#admin_subscriptions', as: 'admin_subscriptions'
  # You can have the root of your site routed with 'root'
  # just remember to delete public/index.html.


  root :to => 'pages#home'

  get  '/new'                                => 'restaurants#new',                    as: 'new_restaurant'
  get  '/:id'                                => 'restaurants#show',                   as: 'restaurant_info'
  get  '/:id/edit'                           => 'restaurants#edit',                   as: 'edit_restaurant'
  get  '/:id/review'                         => 'pages#add_review',                   as: 'add_review_restaurant'
  put  '/:id/update_social_link'             => 'restaurants#update_social_link',     as: 'update_social_link_restaurant'
  post '/:id/add_favourite'                  => 'restaurants#add_favourite',          as: 'add_favourite_restaurant'
  post '/:id/remove_favourite'               => 'restaurants#remove_favourite',       as: 'remove_favourite_restaurant'
# post '/:id/remove_my_favourite'            => 'restaurants#remove_my_favourite',    as: 'remove_my_favourite_restaurant'
  get  '/:id/offer'                          => 'restaurants#offer',                  as: 'offer_restaurant'
  get  '/:id/offer/:offer_id'                => 'restaurants#offer'
  post '/:id/create_offer'                   => 'restaurants#create_offer',           as: 'create_offer_restaurant'
  put  '/:id/update_offer'                   => 'restaurants#update_offer',           as: 'update_offer_restaurant'
  post '/:id/create_review'                  => 'restaurants#create_review',          as: 'create_review_restaurant'
  get  '/:id/report'                         => 'restaurants#show',                   as: 'report_restaurant'
  post '/:id/report'                         => 'restaurants#report'

  # Collections

  resources :collection_images, :only => [:index, :create, :destroy] do
    member do
    end
  end

  get  '/collection/:id/edit'                => 'collections#edit_collection',        as: 'edit_collection'

  # See how all your routes lay out with 'rake routes'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

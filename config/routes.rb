require 'sidekiq/web'

Chippd::Application.routes.draw do
  get "newsletter/index"

  get "newsletter/thanks"

  constraints(ApiConstraint) do
    scope :module => "api" do
      namespace :v1, :path => '1', :defaults => { :format => 'json' } do
        resource :customer, :only => [:create] do
          post 'sign_in'
        end
        get 'pages', :to => 'pages#index'
        get 'pages/not_found', :to => 'pages#not_found', :format => 'html'
        get 'pages/:key', :as => :page, :to => 'pages#show', :format => 'html'
        post 'pages/:key/leave', :as => :leave_page, :to => 'pages#leave'
        get 'pages/*junk', :to => 'pages#not_found', :format => 'html'
      end

      namespace :v2, :path => '2', :defaults => { :format => 'json' } do
        resource :customer, :only => [:create] do
          post 'sign_in'
        end
        get 'pages', :to => 'pages#index'
        get 'pages/not_found', :to => 'pages#not_found', :format => 'html'
        get 'pages/:key', :as => :page, :to => 'pages#show', :format => 'html'
        post 'pages/:key/leave', :as => :leave_page, :to => 'pages#leave'
        get 'pages/*junk', :to => 'pages#not_found', :format => 'html'
        resources :aws_signatures, only: :create, path: 'signatures'
        resources :mobile_playlists, only: :show, path: 'playlists'
      end
    end
  end

  devise_for :customers, :controllers => { :registrations => "customers/registrations", :sessions => "customers/sessions", :passwords => "customers/passwords" }
  devise_for :admins

  authenticate :admin do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  namespace :admin do
    resources :pages
    resources :product_collections, :except => [:show] do
      post 'sort', :on => :collection
      put 'toggle_visibility', :on => :member

      resources :products do
        post 'sort', :on => :collection
        put 'toggle_visibility', :on => :member
      end
    end

    resources :products, :only => nil do
      resources :images, :controller => "product_images" do
        post 'sort', :on => :collection
        put 'toggle_visibility', :on => :member
      end
    end

    resources :page_templates, :except => [:show] do
      post 'sort', :on => :collection
      put 'toggle_visibility', :on => :member
      resources :page_template_widgets, :path => 'widgets', :except => [:show] do
        post 'sort', :on => :collection
        put 'toggle_visibility', :on => :member
      end
    end
    resources :batches, :except => [:edit, :update, :destroy]
    resources :landing_pages do
      put 'toggle_visibility', :on => :member
      resources :steps, :controller => 'landing_page_steps' do
        post 'sort', :on => :collection
        put 'toggle_visibility', :on => :member
      end
      resources :images, :controller => 'landing_page_images' do
        post 'sort', :on => :collection
        put 'toggle_visibility', :on => :member
      end
    end
    root :to => "base#home"
    post 'markdown_preview', :to => "base#markdown_preview"

    resources :contact_requests, :only => [:index, :show, :destroy]
    resources :dollar_amount_discounts, :only => [:new, :edit, :create, :update]
    resources :percentage_discounts, :only => [:new, :edit, :create, :update]
    resources :discounts, :only => [:index, :toggle_visibility, :destroy] do
      put 'toggle_visibility', :on => :member
    end

    resources :shipping_options do
      post 'sort', :on => :collection
      put 'toggle_visibility', :on => :member
    end

    resources :chippd_product_types, :path => 'settings' do
      post 'sort', :on => :collection
      put 'toggle_visibility', :on => :member
    end

    resources :faqs do
      post 'sort', :on => :collection
      put 'toggle_visibility', :on => :member
    end

    resources :press_releases do
      post 'sort', :on => :collection
      put 'toggle_visibility', :on => :member
    end

    resources :contents

    resources :orders, :only => [:index, :edit, :update] do
      post 'search', :on => :collection
      get 'paid', :on => :collection
      get 'shipped', :on => :collection
      get 'canceled', :on => :collection
      put 'ship', :on => :member
      put 'cancel', :on => :member
      get 'invoice', :on => :member
    end

    resources :customers, :only => [:index, :show] do
      get 'line_items', :on => :collection
      get 'confirm', :on => :member
    end
  end

  namespace :store do
    root :to => "product_collections#index"
    get ':product_collection_id/products', :to => "products#index", :as => :products_by_product_collection
    get ':product_collection_id/:page_template_id/products', :to => "products#index_by_page_template", :as => :products_by_product_collection_and_page_template
    resources :products, :only => [:show] do
      resources :preorders, :only => [:create]
    end
    resource :order, :only => [:show, :update] do
      get 'cart', :as => :cart_for
      put 'cart/save', :action => 'save_cart', :as => :save_cart_for
      get 'customer_information', :as => :customer_information_for
      put 'customer_information/save', :action => 'save_customer_information', :as => :save_customer_information_for
      get 'review'
      put 'complete'
      get 'thank_you', :as => :thank_you_for_your
      get 'error', :as => :error_on_your
      resources :line_items, :only => [:create, :destroy]
      resource :applied_discount, :only => :destroy
    end
  end

  namespace :my_chippd, :path => 'my-chippd' do
    root :to => "base#index"
    resource :profile, :only => [:edit, :update, :destroy]
    resources :redemptions, :path => 'redeem', :only => [:index, :create] do
      get 'verify', :on => :collection
    end
    resources :pages, :only => [:index, :show, :edit, :update] do
      get 'chooser', :on => :collection, :as => :chooser_for
      put 'add_to_or_create', :on => :collection
      get 'example', :on => :collection
      post 'notify', :on => :member

      resources :memberships, :only => [:toggle_access] do
        put 'toggle_access', :on => :member
      end
      resources :auctions, :only => [] do
        post 'bid',   :on => :member
        get  'close', :on => :member
        get  'show',  :on => :collection
      end

      resources :sections do
        configatron.pages.valid_section_types.each do |section_type|
          get [:new, section_type].join('-'), :action => [:new, section_type].join('_'), :on => :collection, :as => [:new, section_type, :for].join('_')
        end
        delete 'reset', :on => :collection
        post 'sort', :on => :collection
        get 'download_vcard', :on => :member
        get 'content', :on => :member
        put 'toggle_visibility', :on => :member
      end
    end
  end
  post '/pusher/auth', to: 'my_chippd/base#pusher_auth'

  resources :rsvps, :only => [] do
    resources :responses, :only => [:index, :create, :update, :destroy], :controller => 'my_chippd/rsvp_responses'
  end

  get '/about-us', :to => "pages#about_us", :as => :about_us
  get '/go', :to => "pages#go"
  get '/how-it-works', :to => "pages#how_it_works", :as => :how_it_works
  get '/faq', :to => "pages#faq"
  get '/retailers', :to => "pages#retailers"
  get '/terms-of-service', :to => "pages#terms_of_service", :as => :terms_of_service
  get '/privacy-policy', :to => "pages#privacy_policy", :as => :privacy_policy
  get '/media-room', :to => "pages#media_room", :as => :media_room

  get '/newsletter', :to => "newsletter#index"
  get '/newsletter/thanks', :to => "newsletter#thanks"

  get '/widgets/baby', :to => "widgets#baby"
  get '/widgets/wedding', :to => "widgets#wedding"


  get '/contact-us', :to => "contact_requests#new", :as => :contact_us
  get '/contact-us/thank-you', :to => "contact_requests#thank_you", :as => :contact_request_thank_you
  resources :contact_requests, :only => [:new, :create], :path => 'contact-requests'

  get '/redeem', to: redirect('/activate')
  get '/activate', :to => "pages#redeem_tracking", as: 'redeem'

  resources :press_releases, :only => [:index, :show], :path => 'press'

  configatron.example_pages.each do |path, id|
    get "/examples/#{path.to_s.dasherize}", :to => "examples#show", :as => "#{path}_example", :id => id, :key => path
  end
  get "/ebolaandbeyond", :to => "my_chippd/auctions#show", :page_id => "54d274234c06fcc008000001"
  get "/ppaiexpoeast", :to => "examples#show", :page_id => "54f68261ee2cb7efa9000002", :as => "ppaiexpoeast_example", :id => '54f68261ee2cb7efa9000002', :key => 'ppaiexpoeast'
  get "/intro", :to => "examples#show", :page_id => "54f684a4ee2cb7efa9000003", :as => "intro_example", :id => '54f684a4ee2cb7efa9000003', :key => 'ppaiexpoeast'
  # get "/omaranddina", :to => "my_chippd/auctions#show", :page_id => "54eeb4b63672bcb7c0000028"
  get "/omaranddina", :to => "examples#show", :page_id => "5523084ff400bf85be000001", :as => "omaranddina_example", :id => '5523084ff400bf85be000001', :key => 'omaranddina'

  root :to => "pages#home"
  get '/:id', :to => 'landing_pages#show'
end

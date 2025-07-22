Rails.application.routes.draw do
  resources :conversations, only: [ :index, :create, :show ] do
    resources :messages, only: [ :create ]
  end

  resources :favorites, only: [ :index, :create ]
  delete "favorites/:id", to: "favorites#destroy", as: :favorite
  resources :cars, only: [ :index, :show ] do
    resources :reviews, only: [ :create, :destroy ]
    resources :price_alerts, only: [ :create ]
  end

  # Estimate routes
  get "estimates/start", to: "estimates#start"
  post "estimates/calculate", to: "estimates#calculate"
  get "estimates/quote_popup", to: "estimates#quote_popup"

  resources :car_comparisons, only: [ :index ] do
    collection do
      post :add
      delete :remove
      delete :clear
    end
  end

  resources :price_alerts, only: [ :index, :destroy ]
  resources :notifications, only: [ :index ] do
    member do
      patch :mark_as_read
    end
    collection do
      patch :mark_all_as_read
    end
  end

  resource :user, only: [ :show, :edit, :update ]

  scope :admin do
    get "/", to: "admin#index", as: :admin
    resources :users, only: [ :edit, :update, :destroy ], controller: "admin", as: :admin_users
    resources :cars, only: [ :new, :create, :edit, :update, :destroy ], controller: "admin", as: :admin_cars
  end

  devise_for :users, controllers: { sessions: 'sessions' }
  root "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end

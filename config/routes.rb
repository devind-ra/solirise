Rails.application.routes.draw do
  get "admin_home/index"
  get "home/index", as: :home
  root "landing#index"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }
  get "admin_home", to: "admin_home#index", as: :admin_home
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :appraisals, only: [ :index, :destroy ] do
    resources :entries, only: [ :new, :create, :destroy, :update, :edit ] do
      get 'view', on: :member
    end
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end

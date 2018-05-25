Rails.application.routes.draw do

  resources :courses do
    collection do
      resources :review_requests, only: ['index', 'destroy']
    end
    member do
      put :validate_and_save, to: 'courses#validate_and_save'
      get :publish_page, to: 'courses#publish_page'
      put :publish, to: 'courses#publish'
      get :passing, to: 'passing_courses#show'
      put :save_progress, to: 'passing_courses#save_progress'
      put :check_answers, to: 'passing_courses#check_answers'
      put :rate, to: 'ratings#rate'
      put :add_to_favorites, to: 'favorites#add_to_favorites'
      delete :remove_from_favorites, to: 'favorites#remove_from_favorites'
    end
    resources :certificate_templates do
      member do
        put :attach, to: 'certificate_templates#attach'
      end
    end
    resources :certificates, only: [:show]
  end

  resources :organizations do
    resources :roles, only: %i[create update new destroy]
    resources :courses, module: :organizations, only: :index
    resources :users, module: :organizations, only: :index
    resources :impersonations, module: :organizations, only: :index
    resources :reports, module: :organizations, only: :index
    member do
      get 'add_users_to', action: :add_users
      get 'add_admins_to', action: :add_admins
      get 'profile', action: :profile, as: :profile
      post 'invite', action: :invite
      post 'invite_from_csv', action: :invite_from_csv
      patch 'process_request', action: :process_request
    end
  end

  get :dashboard, to: 'dashboard#index'
  get :search, to: 'search#index'
  namespace :dashboard do
    namespace :courses do
      get :current
      get :from_organizations
      get :from_users
      get :starred
      get :passed
      get :recommended
    end
  end

  get :orgadmin_dashboard, to: 'orgadmin_dashboard#index'

  devise_for :users, controllers: { registrations: 'users/registrations',
                                    sessions: 'users/sessions' }

  authenticated :user do
    root 'dashboard#index'
  end
  root 'static_pages#main'

  resources :users do
    member do
      patch :impersonate
      delete :stop_impersonation
    end
    resources :courses, module: :users, only: :index
    resources :certificates, module: :users, only: :index
  end

  resources :messages do
    collection do
      delete :trash, to: 'messages#empty_trash'
    end
    member do
      patch :restore, to: 'messages#restore'
    end
  end
  namespace :autocomplete do
    get :users
    get :organizations
    get :users_to_organization
    get :users_to_orgadmins
  end
end

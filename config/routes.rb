require "api_constraints"

Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: {format: "json"} do
    devise_scope :user do
      post "sign_up", to: "registrations#create"
      post "sign_in", to: "sessions#create"
      delete "sign_out", to: "sessions#destroy"
      get "confirmation", to: "confirmations#new"
      put "confirmation", to: "confirmations#update"
      get "password", to: "passwords#new"
      post "password", to: "passwords#create"
      put "password", to: "passwords#update"
    end

    scope module: :v1, constraints: ApiConstraints.new(version: 1,
      default: true) do
      resources :users, only: [:show, :update, :index]
      resources :invoices, only: :index
      namespace :shipper do
        resources :invoices, only: [:update, :index, :show]
        resources :user_invoices, only: [:create, :destroy]
        resources :rates, only: [:create, :update, :destroy]
        resources :reports, only: :create
      end
      namespace :shop do
        resources :invoices, except: [:edit, :new]
        resources :user_invoices, only: :update
        resources :list_shippers, only: :index
        resources :reports, only: :create
        resources :rates, only: [:create, :update, :destroy]
      end
    end
  end
end

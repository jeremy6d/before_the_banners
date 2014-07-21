require 'mongoid/grid_fs'

Rails.application.routes.draw do
  devise_for :users
  resources :projects do
    resources :updates, except: :index
    member do
      get "authorizations" => "authorizations#index", as: :authorizations_for
      put "authorizations" => "authorizations#update", as: :update_authorizations_for
    end
  end

  get "/media/*path" => "grid_fs#serve"

  root to: "projects#index"
end

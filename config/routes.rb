require 'mongoid/grid_fs'

Rails.application.routes.draw do
  devise_for :users
  resources :projects do
    resources :updates, except: :index
  end

  get "/media/*path" => "grid_fs#serve"

  root to: "projects#index"
end

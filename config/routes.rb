Rails.application.routes.draw do
  get 'static/index'

  resources :workspaces

  get "/media/*path" => "grid_fs#serve"
  get "/widgets/:project_id" => "widgets#basic"

  devise_for :users, controllers: { registrations: "registrations", invitations: "invitations" }
  # devise_scope(:users) do
  #   get "projects/:project_id/invite" => "project_invitations#new"
  #   post "projects/:project_id/invitation" => "project_invitations#create"
  # end
  resource :company
  resources :projects do
    resources :workspaces do
      collection do
        put 'sort' => "workspaces#sort"
      end
    end
    resources :updates, except: :index
    member do
      get "authorizations" => "authorizations#index", as: :authorizations_for
      put "authorizations" => "authorizations#update", as: :update_authorizations_for
    end
  end

  authenticated :user do
    root to: "projects#index", as: :dashboard # future dashboard 
  end

  root to: "static#index"
end

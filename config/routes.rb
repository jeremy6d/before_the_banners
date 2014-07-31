Rails.application.routes.draw do
  get "/media/*path" => "grid_fs#serve"

  devise_for :users, controllers: { registrations: "registrations", invitations: "invitations" }
  # devise_scope(:users) do
  #   get "projects/:project_id/invite" => "project_invitations#new"
  #   post "projects/:project_id/invitation" => "project_invitations#create"
  # end
  resource :company
  resources :projects do
    resources :updates, except: :index
    member do
      get "authorizations" => "authorizations#index", as: :authorizations_for
      put "authorizations" => "authorizations#update", as: :update_authorizations_for
    end
  end

  root to: "projects#index"
end

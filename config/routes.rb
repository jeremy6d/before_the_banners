Rails.application.routes.draw do
  devise_for :users
  resources :projects do
    resources :updates, except: :index
  end

  root to: "projects#index"
end

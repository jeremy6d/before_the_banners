require 'mongoid/grid_fs'

Rails.application.routes.draw do
  devise_for :users
  resources :projects do
    resources :updates, except: :index
  end

  get "/media/*path" => proc { |env|
    byebug
    gridfs_path = env["PATH_INFO"].gsub("/media/", "")
    begin
      gridfs_file = Mongoid::GridFS[gridfs_path]      
      [ 200, { 'Content-Type' => gridfs_file.content_type, 'Content-Length' => gridfs_file.file_length.to_s }, gridfs_file ]
    rescue
      message = 'Grid file not found.'
      [ 404, { 'Content-Type' => 'text/plain' }, message ]
    end
  }
  root to: "projects#index"
end

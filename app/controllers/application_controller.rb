class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  http_basic_authenticate_with :name => "btb", :password => "leanasfuck", :if => Proc.new { Rails.env.production? }
  before_action :configure_permitted_parameters, if: :devise_controller?

protected
  def configure_permitted_parameters
    %i(sign_up account_update).each do |type|
      devise_parameter_sanitizer.for(type).concat [:first_name,
                                                   :last_name,
                                                   :email,
                                                   :password,
                                                   :password_confirmation,
                                                   :avatar,
                                                   :avatar_cache,
                                                   company_attributes: [ :title ]]
    end

    devise_parameter_sanitizer.for(:invite).concat [ :email, project_ids: [] ]
    devise_parameter_sanitizer.for(:accept_invitation).concat [ :first_name, 
                                                                :last_name,
                                                                :password,
                                                                :password_confirmation,
                                                                company_attributes: [ :title ]]
  end

  def punt! message = nil
    redirect_to root_path, alert: (message || "You are not authorized to access that resource.")
  end
end
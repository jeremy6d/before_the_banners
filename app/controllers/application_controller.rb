class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

protected
  def configure_permitted_parameters
    %i(sign_up account_update).each do |type|
      devise_parameter_sanitizer.for(type).concat [:first_name, :last_name, :company_name]
    end
  end
end
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

protected
  def set_up_sign_up_form
    @user ||= User.new
    @company ||= @user.build_company
  end

  def configure_permitted_parameters
    %i(sign_up account_update).each do |type|
      devise_parameter_sanitizer.permit type, keys: [:first_name,
                                                     :last_name,
                                                     :email,
                                                     :password,
                                                     :password_confirmation,
                                                     :avatar,
                                                     :avatar_cache,
                                                     company_attributes: [ :title ]]
    end

    devise_parameter_sanitizer.permit :invite, keys: [ :email, project_ids: [] ]
    devise_parameter_sanitizer.permit :accept_invitation, keys: [ :first_name, 
                                                                  :last_name,
                                                                  :password,
                                                                  :password_confirmation,
                                                                  company_attributes: [ :title ]]
  end

  def punt! message = nil
    redirect_to root_path, alert: (message || "You are not authorized to access that resource.")
  end

  def after_sign_in_path_for(resource_or_scope)
    projects_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_up_path_for(resource_or_scope)
    new_project_path
  end
end
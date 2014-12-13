class RegistrationsController < DeviseInvitable::RegistrationsController
  def new
    set_up_sign_up_form
    respond_with @user
  end

  def create
    @user = User.new(sign_up_params)

    if @user.save
      if @user.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(:user, @user)
        redirect_to new_project_path, notice: "Get started by setting up your first project!"
      else
        set_flash_message :notice, :"signed_up_but_#{@user.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with @user, location: after_inactive_sign_up_path_for(@user)
      end
    else
      set_up_sign_up_form
      clean_up_passwords @user
      respond_with @user
    end
  end
end
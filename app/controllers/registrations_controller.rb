class RegistrationsController < DeviseInvitable::RegistrationsController
  def new
    @user = User.new
    @company = @user.build_company
    respond_with @user
  end

  def create
    @user = User.new(sign_up_params)

    if @user.save
      if @user.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(:user, @user)
        respond_with @user, location: after_sign_up_path_for(@user)
      else
        set_flash_message :notice, :"signed_up_but_#{@user.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with @user, location: after_inactive_sign_up_path_for(@user)
      end
    else
      @company = @user.company
      clean_up_passwords @user
      respond_with @user
    end
  end
end
class StaticController < ApplicationController
  def index
    @user = User.new
    @company = @user.build_company

    render layout: false

    set_up_sign_up_form
  end
end

class StaticController < ApplicationController
  def index
    @user = User.new
    @company = @user.build_company

    render layout: "homepage"
  end
end

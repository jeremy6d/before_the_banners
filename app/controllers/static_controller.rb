class StaticController < ApplicationController
  layout false

  def index
    set_up_sign_up_form
  end
end

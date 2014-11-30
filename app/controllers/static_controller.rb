class StaticController < ApplicationController
  def index
    render layout: "homepage"
  end
end

class WidgetsController < ApplicationController

  skip_before_action :verify_authenticity_token
  
  layout false

  def basic
    @project = Project.find params[:project_id]
    respond_to do |format|
      format.js
    end
  end
end
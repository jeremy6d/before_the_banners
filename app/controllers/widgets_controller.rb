class WidgetsController < ApplicationController
  layout false
  def basic
    @project = Project.find params[:project_id]
  end
end
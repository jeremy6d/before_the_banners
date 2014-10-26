class UpdatesController < ApplicationController
  inherit_resources
  actions :all, except: :index
  belongs_to :project
  
  def create
    @project = parent
    @update = @project.updates.build update_params
    @update.author = current_user
    create! do |success, failure|
      success.html { redirect_to project_path(@project), notice: "Update submitted." }
    end
  end

protected
  def update_params
    params.require(:update).permit :title,
                                   :body,
                                   :attachment,
                                   :attachment_cache,
                                   :workspace_id
  end
end

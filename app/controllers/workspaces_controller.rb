class WorkspacesController < ApplicationController
  inherit_resources
  belongs_to :project
  before_action :authorize_for_administration, except: %i(index show)
  custom_actions collection: :sort

  def sort
    params["workspace"].each_with_index do |workspace_name, index|
      Workspace.find(workspace_name).update(sequence: index)
    end

    render nothing: true
  end

  # def index
  #   collection
  # end

protected
  def authorize_for_administration
    punt! unless current_user.authorized?(to: Authorization::ADMINISTER, on: parent)
  end

  def workspace_params
    params.require(:workspace).permit :title,
                                      :description,
                                      :sequence,
                                      :attachment,
                                      :attachment_cache
  end

  def collection
    @workspaces ||= end_of_association_chain.asc(:sequence)
  end
end

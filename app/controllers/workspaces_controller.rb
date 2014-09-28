class WorkspacesController < ApplicationController
  inherit_resources
  belongs_to :project
  before_action :authorize_for_administration, except: %i(index show)

protected
  def authorize_for_administration
    punt! unless current_user.authorized?(to: Authorization::ADMINISTER, on: parent)
  end

  def workspace_params
    params.require(:workspace).permit :title,
                                      :description,
                                      :sequence
  end
end

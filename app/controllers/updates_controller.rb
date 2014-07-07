class UpdatesController < ApplicationController
  inherit_resources
  actions :all, except: :index
  belongs_to :project

protected
  def update_params
    params.require(:update).permit :title,
                                   :body
  end
end

class ProjectsController < ApplicationController
  inherit_resources

protected
  def project_params
    params.require(:project).permit :title, 
                                    :type,
                                    :value,
                                    :owner_name,
                                    :architect_name,
                                    :builder_name,
                                    :description,
                                    :starts_at,
                                    :ends_at
  end
end

class ProjectsController < ApplicationController
  inherit_resources
  before_action :authorize_for_administration, only: %i(edit update destroy)
  
  def show
    @workspaces = resource.workspaces
    @current_workspace = @workspaces.to_a.find { |w| w.slug == params[:workspace] }
    @updates = @project.updates.desc(:created_at)
    @updates = @updates.where(workspace: @current_workspace) if @current_workspace

    render layout: "project_page"
  end

  def create
    @project = Project.new project_params
    @project.creator = current_user

    if @project.save
      redirect_to @project, notice: "Project created."
    else
      flash.now[:alert] = "Project could not be saved."
      render :new
    end
  end

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
                                    :ends_at,
                                    :logo,
                                    :logo_cache,
                                    :owner_title,
                                    :architect_title,
                                    :builder_title
  end

  def collection
    @projects ||= current_user.projects
  end

  def authorize_for_administration
    punt! unless current_user.authorized?(to: Authorization::ADMINISTER, on: resource)
  end
end

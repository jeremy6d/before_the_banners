class AuthorizationsController < ApplicationController
  def index
    @project = Project.find(params[:id])
    @members = @project.members
  end

  def update
    @project = Project.find(params[:id])
    params[:members].each do |mid, types|
      member = @project.members.find(mid)
      Authorization.types.each do |type|
        if types.include? type
          member.authorizations.find_or_create_by(project_id: @project.id, name: type)
        else
          member.authorizations.destroy_all(project_id: @project.id, name: type)
        end
      end
    end

    redirect_to @project, notice: "Project authorization updated."
  end

protected
  def authorizations_params
    params.permit! 
  end
end
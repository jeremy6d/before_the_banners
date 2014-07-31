class InvitationsController < Devise::InvitationsController
  def new
    @user = User.new
  end

  def create
    if @user = User.where(email: params[:user][:email]).first
      @user.project_ids += params[:user][:project_ids]
      @user.authorizations += auth_records
      @user.save
    else
      attrs = invite_params.merge! company: get_company,
                                   project_ids: params[:user][:project_ids],
                                   authorizations: auth_records.map(&:attributes)
      @user = User.invite! attrs, current_user
    end

    redirect_to root_path, notice: "You have added #{@user.email} to this project."
  end

  def edit
    @user = resource
    @user.invitation_token = params[:invitation_token]
    @company = @user.company || @user.build_company
  end

protected
  def load_project
    @project = current_user.projects.authorized_to(Authorization::ADMINISTER).find(params[:project_id])
  end

  def get_company
    Company.where(email_domain: invite_params[:email].split("@").last).first
  end

  def auth_records
    @auth_records ||= params.delete('project_auth').to_a.map { |proj_id, auth_names|
      next unless params[:user][:project_ids].include? proj_id

      auth_names.to_a.map do |name|
        Authorization.new name: name, project_id: proj_id, grantor_name: current_user.full_name
      end
    }.flatten.compact
  end
end
class InvitationsController < Devise::InvitationsController
  def new
    @user = User.new
  end

  def create
    if @user = User.where(email: params[:user][:email]).first
      project_names = Project.only(:title).
                              find(params[:user][:project_ids] - @user.project_ids).
                              map(&:title).
                              to_sentence

      @user.project_ids += params[:user][:project_ids]
      @user.authorizations += auth_records
      @user.save
      @user.notify! "You have been invited to #{project_names}."
    else
      @company = lookup_existing_company 
      attrs = invite_params.merge! company: @company,
                                   project_ids: params[:user][:project_ids],
                                   authorizations: auth_records.map(&:attributes)
      @user = User.invite! attrs, current_user
      @company ||= @user.company || @user.build_company 
    end

    redirect_to root_path, notice: "Your invitation was sent."
  end

  def edit
    @user = resource
    @user.invitation_token = params[:invitation_token]
    @company = @user.company || @user.build_company
  end

  def update
    @user = accept_resource

    if @user.errors.empty?
      flash_message = @user.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message :notice, flash_message if is_flashing_format?
      sign_in(:user, @user)
      respond_with @user, :location => after_accept_path_for(@user)
    else
      respond_with_navigational(@user) do
        @company = @user.company || @user.build_company
        render :edit
      end
    end
  end

protected
  def load_project
    @project = current_user.projects.authorized_to(Authorization::ADMINISTER).find(params[:project_id])
  end

  def lookup_existing_company
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
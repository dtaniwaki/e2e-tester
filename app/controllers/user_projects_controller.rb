class UserProjectsController < BaseController
  def create
    @project = Project.find(params[:project_id])
    authorize @project, :show?
    @user = User.find_or_invite_by({ email: params[:email] }, current_user)
    @user_project = @project.user_projects.with_user(@user).first_or_initialize
    authorize @user_project
    @user_project.assigned_by = current_user

    if @user_project.save
      flash[:notice] = 'Successfully invited the user'
    else
      flash[:alert] = 'Failed to invite the user'
    end
    redirect_to :back
  end

  def update
    @user_project = UserProject.find(params[:id])
    authorize @user_project

    if @user_project.update_attributes(permitted_params)
      flash[:notice] = 'Successfully updated the user project'
    else
      flash[:alert] = 'Failed to update the user project'
    end
    redirect_to :back
  end

  def index
    @project = Project.find(params[:project_id])
    authorize @project, :show?
    @user_projects = policy_scope(@project.user_projects).eager_load(:user).page(params[:page]).per(20)
  end

  private

  def permitted_params
    params.require(:user_project).permit(user_project_variables_attributes: [:id, :name, :value, :_destroy])
  end
end

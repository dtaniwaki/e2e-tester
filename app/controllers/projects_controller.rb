class ProjectsController < BaseController
  auto_decorate :tests, only: [:index, :show]

  def index
    @projects = policy_scope(current_user.accessible_projects).latest.page(params[:page]).per(20)
  end

  def show
    @project = Project.find(params[:id])
    authorize @project

    @tests = @project.tests.preload(test_browsers: :browser).latest.limit(10)
    @user_project = @project.user_projects.with_user(current_user).includes(:user_project_variables).first
    @user_projects = @project.user_projects.eager_load(:user).limit(10)
  end

  def new
    @project = current_user.projects.build
    authorize @project
  end

  def create
    @project = current_user.projects.build
    authorize @project

    if @project.update_attributes(permitted_params)
      flash[:notice] = 'Succesfully created new project'
      redirect_to project_path(@project)
      return
    end
    render :new
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project
  end

  def update
    @project = Project.find(params[:id])
    authorize @project

    if @project.update_attributes(permitted_params)
      flash[:notice] = 'Succesfully created the project'
      redirect_to project_path(@project)
      return
    end
    render :edit
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    authorize @project

    if @project.destroy
      flash[:notice] = 'Succesfully deleted the project'
    else
      flash[:alert] = 'Failed to delete the project'
    end
    redirect_to projects_path
  end

  private

  def permitted_params
    params.require(:project).permit(:title, :description)
  end
end

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = policy_scope(current_user.accessible_projects).latest.page(params[:page]).per(20)
  end

  def show
    @project = Project.eager_load(current_test: :test_steps).find(params[:id])
    authorize @project

    @tests = @project.tests.preload(test_browsers: :browser).latest.limit(10)
    @user_project = @project.user_projects.with_user(current_user).includes(:user_project_variables).first
    @user_projects = @project.user_projects.eager_load(:user).limit(10)
  end

  def new
    @project = current_user.own_projects.build
    authorize @project
  end

  def create
    @project = current_user.own_projects.build
    authorize @project

    if @project.update_attributes(permitted_params)
      flash[:notice] = 'Succesfully created new project'
      redirect_to project_path(@project)
    else
      flash[:alert] = 'Failed to create new project'
      render :new
    end
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
    else
      flash[:alert] = 'Failed to update the project'
      render :edit
    end
  end

  def destroy
    @project = current_user.own_projects.find(params[:id])
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
    params.require(:project).permit(:title)
  end
end

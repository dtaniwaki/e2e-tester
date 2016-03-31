class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = policy_scope(current_user.projects).latest.page(params[:page]).per(20)
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

    @selected_browsers = []
    assign_browsers
  end

  def create
    @project = current_user.own_projects.build
    authorize @project

    if @project.update_attributes(permitted_params)
      flash[:notice] = 'Succesfully created new project'
      redirect_to project_path(@project)
    else
      @selected_browsers = @project.current_test.browsers
      assign_browsers
      render :new
    end
  end

  def edit
    if params[:base_test_id]
      @project = Project.includes(tests: { test_browsers: :browser }).find(params[:id])
      @base_test = @project.tests.eager_load(:test_steps).find(params[:base_test_id])
    else
      @project = Project.includes(:current_test, tests: { test_browsers: :browser }).find(params[:id])
      @base_test = @project.current_test
    end
    authorize @project

    @selected_browsers = @project.current_test.browsers
    assign_browsers
  end

  def update
    @project = Project.includes(:current_test, tests: { test_browsers: :browser }).find(params[:id])
    authorize @project

    if @project.update_attributes(permitted_params)
      flash[:notice] = 'Succesfully created the project'
      redirect_to project_path(@project)
    else
      @selected_browsers = @project.current_test.browsers
      assign_browsers
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

  def assign_browsers
    @browser_sets = BrowserSet.includes(:browsers).all
    @browsers = Browser::Base.active.all
  end

  def permitted_params
    params.require(:project).permit(:title, current_test_attributes: [:test_id, :test_steps_attributes, browser_ids: []])
  end
end

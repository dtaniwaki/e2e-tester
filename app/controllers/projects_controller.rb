class ProjectsController < BaseController
  auto_decorate :tests, only: [:index, :show]

  before_action :assign_base_test_step_set, only: [:new, :create, :edit, :update]
  before_action :assign_browsers, only: [:new, :create, :edit, :update]

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

    @base_test_step_set ||= @project.updating_test
  end

  def create
    @project = current_user.projects.build
    authorize @project

    @project.assign_attributes(permitted_params)
    @project.updating_tests.each do |t|
      t.assign_attributes(user: current_user, base_test_step_set: @base_test_step_set)
    end
    if @project.save
      flash[:notice] = 'Succesfully created new project'
      redirect_to project_path(@project)
      return
    end

    @base_test_step_set = @project.updating_test
    render :new
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project

    @base_test_step_set ||= @project.updating_test
  end

  def update
    @project = Project.find(params[:id])
    authorize @project

    @project.assign_attributes(permitted_params)
    @project.updating_tests.each do |t|
      t.assign_attributes(user: current_user, base_test_step_set: @base_test_step_set || @project.current_test)
    end
    if @project.save
      flash[:notice] = 'Succesfully created the project'
      redirect_to project_path(@project)
      return
    end

    @base_test_step_set = @project.updating_test
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

  def assign_browsers
    @browser_sets = BrowserSet.includes(:browsers).all
    @browsers = Browser::Base.active.all.group_by(&:class).map { |gk, bs| [gk, bs.group_by { |b| [b.os, b.os_version] }] }
  end

  def assign_base_test_step_set
    @base_test_step_set = (params[:base_test_step_set_id].presence && TestStepSet.find(params[:base_test_step_set_id]))
    return if @base_test_step_set.nil?
    authorize @base_test_step_set, :show?
    @base_test_step_set = @base_test_step_set.becomes Test
  end

  def permitted_params
    params.require(:project).permit(
      updating_tests_attributes: [
        :title, :description,
        test_steps_attributes:
          [:test_step_type, :_destroy, :shared_test_step_set_id, data: [:message, :selector, :javascript, :value, :url, :width, :height, :duration]],
        browser_ids: []
      ]
    )
  end
end

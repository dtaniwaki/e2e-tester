class ProjectTestsController < BaseController
  before_action :assign_project

  def index
    @tests = policy_scope(@project.tests).latest.page(params[:page]).per(20)
  end

  def new
    @test = @base_test_step_set = (params[:base_test_step_set_id].presence && @project.tests.find(params[:base_test_step_set_id]))
    @test ||= @project.tests.build
    authorize @test

    @selected_browsers = @test&.browsers || []
    assign_browsers
  end

  def create
    @base_test_step_set = (params[:base_test_step_set_id].presence && @project.tests.find(params[:base_test_step_set_id]))
    authorize @base_test_step_set if @base_test_step_set.present?

    @test = @project.tests.build(permitted_params.merge(user: current_user, base_test_step_set: @base_test_step_set))
    authorize @test

    return redirect_to project_path(@project) if @test.same_test_step_set?(@base_test_step_set)
    if @test.save
      flash[:notice] = 'Succesfully created new test'
      return redirect_to project_path(@project)
    end
    @selected_browsers = @test&.browsers || []
    assign_browsers
    render :new
  end

  private

  def assign_project
    @project = current_user.accessible_projects.find(params[:project_id])
    authorize @project, :show?
  end

  def assign_browsers
    @browser_sets = BrowserSet.includes(:browsers).all
    @browsers = Browser::Base.active.all
  end

  def permitted_params
    params.require(:test).permit(:title, :description, :test_steps_attributes, browser_ids: [])
  end
end

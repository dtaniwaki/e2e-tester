class TestsController < BaseController
  before_action :assign_project, only: [:index, :new, :create]

  def index
    @tests = policy_scope(@project.tests).latest.page(params[:page]).per(20)
  end

  def show
    @test = Test.includes(:project, test_browsers: :browser).find(params[:id])
    authorize @test

    if current_user.user_projects.with_project(@test.project).exists?
      @test_executions = @test.test_executions.eager_load(:user).latest.limit(10)
    elsif current_user.user_tests.with_test(@test).exists?
      @test_executions = current_user.test_executions.with_test(@test).eager_load(:user).latest.limit(10)
      @user_test = @test.user_tests.with_user(current_user).eager_load(:user_test_variables).first!
    end
    @is_owner = current_user.user_projects.with_project(@test.project).exists?
    @user_tests = @test.user_tests.eager_load(:user).limit(10) if @is_owner
  end

  def new
    @base_test_step_set = (params[:base_test_step_set_id].presence && TestStepSet.find(params[:base_test_step_set_id]))
    if @base_test_step_set.present?
      @base_test_step_set = @base_test_step_set.becomes! @base_test_step_set.type.constantize
      authorize @base_test_step_set
    end

    @test = @base_test_step_set
    @test ||= @project.tests.build

    @selected_browsers = @test&.browsers || []
    assign_browsers
  end

  def create
    @base_test_step_set = (params[:base_test_step_set_id].presence && TestStepSet.find(params[:base_test_step_set_id]))
    if @base_test_step_set.present?
      @base_test_step_set = @base_test_step_set.becomes! @base_test_step_set.type.constantize
      authorize @base_test_step_set
    end

    @test = @project.tests.build(permitted_create_params.merge(user: current_user, base_test_step_set: @base_test_step_set))
    authorize @test

    return redirect_to test_path(@base_test_step_set) if @test.same_test_step_set?(@base_test_step_set)
    if @test.save
      flash[:notice] = 'Succesfully created new test'
      return redirect_to test_path(@test)
    end
    @selected_browsers = @test&.browsers || []
    assign_browsers
    render :new
  end

  def edit
    @test = Test.find(params[:id])
    authorize @test
  end

  def update
    @test = Test.find(params[:id])
    authorize @test

    if @test.update_attributes(permitted_update_params)
      flash[:notice] = 'Succesfully created new test'
      return redirect_to test_path(@test)
    end
    render :edit
  end

  def destroy
    @test = Test.find(params[:id])
    authorize @test

    @test.destroy!

    flash[:alert] = 'Succesfully deleted the test'
    redirect_to project_tests_path(@test.project)
  end

  private

  def assign_project
    @project = Project.find(params[:project_id])
    authorize @project, :show?
  end

  def assign_browsers
    @browser_sets = BrowserSet.includes(:browsers).all
    @browsers = Browser::Base.active.all
  end

  def permitted_create_params
    params.require(:test).permit(:title, :description, :test_steps_attributes, browser_ids: [])
  end

  def permitted_update_params
    params.require(:test).permit(:title, :description)
  end
end

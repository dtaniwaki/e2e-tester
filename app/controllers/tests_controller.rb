class TestsController < BaseController
  auto_decorate :tests, :test, only: [:index, :show]

  def index
    @project = Project.find(params[:project_id])
    authorize @project, :show?

    @tests = policy_scope(@project.tests).latest.page(params[:page]).per(20)
  end

  def show
    @test = Test.includes(:project, test_browsers: :browser).find(params[:id])
    authorize @test
    @project = @test.project

    if current_user.user_projects.with_project(@test.project).exists?
      @test_executions = @test.test_executions.eager_load(:user).latest.limit(10)
    elsif current_user.user_tests.with_test(@test).exists?
      @test_executions = current_user.test_executions.with_test(@test).eager_load(:user).latest.limit(10)
      @user_test = @test.user_tests.with_user(current_user).eager_load(:user_test_variables).first!
    end
    @user_tests = @test.user_tests.eager_load(:user).limit(10) if policy(@test.project).show?
  end

  def destroy
    @test = Test.find(params[:id])
    authorize @test

    @test.destroy!

    flash[:alert] = 'Succesfully deleted the test'
    redirect_to project_tests_path(@test.project)
  end
end

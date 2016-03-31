class TestExecutionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @test = Test.find(params[:test_id])
    authorize @test, :show?

    @test_executions = if current_user.user_projects.with_project(@test.project).exists?
      policy_scope(@test.test_executions).eager_load(:user).latest.page(params[:page]).per(20)
    else
      policy_scope(@test.test_executions.with_user(current_user)).eager_load(:user).latest.page(params[:page]).per(20)
    end
  end

  def show
    @test_execution = TestExecution.includes(test_execution_browsers: [:browser, :test_step_executions], test: :test_steps).find(params[:id])
    authorize @test_execution
  end

  def create
    @test = Test.find(params[:test_id])
    authorize @test, :show?
    @test_execution = @test.test_executions.with_user(current_user).build
    authorize @test_execution
    if @test_execution.save
      @test_execution.execute_async!(current_user)
      flash[:notice] = 'Successfully executed the test'
      redirect_to test_execution_path(@test_execution)
    else
      flash[:alert] = @test_execution.errors.full_messages.join
      redirect_to :back
    end
  end

  def done
    @test_execution = current_user.test_executions.includes(test_execution_browsers: { test_step_executions: :test_step }).find(params[:id])
    authorize @test_execution

    @test_execution_browsers = @test_execution.test_execution_browsers
  end
end

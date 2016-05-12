class TestStepExecutionsController < BaseController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @test_step_execution = TestStepExecution.preload(:browser, :test_step, :screenshot, test_execution: { test_version: :test_steps }).find(params[:id])
    token = params[:token]
    if token
      @test_step_execution.test_execution.token = token
    else
      authenticate_user!
    end
    authorize @test_step_execution

    @test_steps = @test_step_execution.test_execution.test_version.test_steps
    target_executions = TestStepExecution.with_test_execution(@test_step_execution.test_execution)
    @same_browser_test_step_executions = target_executions.with_browser(@test_step_execution.browser).preload(:test_step)
    @other_browser_test_step_executions = target_executions.with_test_step(@test_step_execution.test_step).preload(:browser)
  end
end

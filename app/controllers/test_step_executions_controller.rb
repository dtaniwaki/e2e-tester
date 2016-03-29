class TestStepExecutionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @test_step_execution = TestStepExecution.preload(:browser, :test_step, :screenshot, :test_execution).find(params[:id])
    authorize @test_step_execution

    target_executions = TestStepExecution.with_test_execution(@test_step_execution.test_execution)
    @same_browser_test_step_executions = target_executions.with_browser(@test_step_execution.browser).preload(:test_step)
    @other_browser_test_step_executions = target_executions.with_test_step(@test_step_execution.test_step).preload(:browser)
  end
end

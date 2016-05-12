class TestExecutionShareDecorator < Draper::Decorator
  delegate_all

  def test_execution_url
    helpers.test_execution_url(object.test_execution, token: object.token)
  end
end

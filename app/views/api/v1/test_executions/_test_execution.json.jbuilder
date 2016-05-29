test_version = test_execution.test_version
user = test_execution.user
json.id test_execution.to_param
json.test_version do
  json.id test_version.test.to_param
  json.number test_version.position
  json.url api_v1_test_version_position_url(test_version)
  json.html_url test_version_position_url(test_version)
end
json.extract! test_execution, :state, :executed_at, :created_at, :updated_at
json.executed_by do
  json.id user.to_param
  json.extract! user, :username, :name
end
json.url api_v1_test_execution_url(test_execution)
json.html_url test_execution_url(test_execution)
json.browsers test_version.browsers do |browser|
  json.id browser.to_param
  json.type browser.browser_type
  json.extract! browser, :full_name, :name, :os, :os_version, :browser, :browser_version, :device
  json.test_steps test_version.test_steps do |step|
    json.id step.to_param
    json.type step.test_step_type
    json.extract! step, :to_line
    browser_execution = test_execution.test_execution_browsers.find { |teb| teb.browser == browser }
    if browser_execution
      step_execution = browser_execution.test_step_executions.find { |tse| tse.step == step }
      if step_execution
        json.execution do
          json.id step_execution.to_param
          json.screenshot_url step_execution.screenshot.image.url if step.screenshot?
          json.page_source_url step_execution.page_source.source.url if step.page_source?
          # json.url api_v1_test_step_execution_url(step_execution)
          json.html_url test_step_execution_url(step_execution)
        end
      end
    end
  end
end

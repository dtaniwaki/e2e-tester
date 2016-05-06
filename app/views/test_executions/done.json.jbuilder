json.data(id: @test_execution.to_param,
          state: @test_execution.state,
          browsers: @test_execution_browsers.map do |teb|
                      {
                        id: teb.to_param,
                        state: teb.state,
                        message: teb.error,
                        steps: teb.test_step_executions.map do |tse|
                          h = {
                            id: tse.to_param,
                            test_step_id: tse.test_step.to_param,
                            state: tse.state,
                            link_url: test_step_execution_path(tse)
                          }
                          if tse.test_step.screenshot? && tse.screenshot.present?
                            h[:screenshot] = {
                              image_url: tse.screenshot.image.url(:thumb)
                            }
                          end
                          h
                        end
                      }
                    end)

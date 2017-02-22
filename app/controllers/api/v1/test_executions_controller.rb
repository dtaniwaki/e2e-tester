module Api
  module V1
    class TestExecutionsController < Api::V1::BaseController
      swagger_path '/tests/{test_id}/{number}/test_executions' do # rubocop:disable Metrics/BlockLength
        parameter name: :test_id, in: :path,
                  description: 'ID of test version to execute',
                  required: true,
                  type: :string
        parameter name: :number,
                  in: :path,
                  description: 'Version of test version to execute',
                  required: true,
                  type: :integer
        operation :get do
          key :tags, %w(test_executions)
          parameter name: :page,
                    in: :query,
                    description: 'Page number',
                    required: false,
                    type: :integer
          security { key :Bearer, [] }
          response 200
          response 401
          response 403
          response 404
        end
        operation :post do
          key :tags, %w(test_executions)
          security { key :Bearer, [] }
          response 201
          response 401
          response 403
          response 404
        end
      end
      swagger_path '/test_executions/{id}' do
        parameter name: :id, in: :path,
                  description: 'ID of test execution to execute',
                  required: true,
                  type: :string
        operation :get do
          key :tags, %w(test_executions)
          security { key :Bearer, [] }
          response 200
          response 401
          response 403
          response 404
        end
      end

      def index
        @test_version = Test.find(params[:test_id]).test_versions.find_by!(position: params[:number])
        authorize @test_version, :show?

        @test_executions = policy_scope(@test_version.test_executions, @test_version)
                           .includes(test_execution_browsers: [:browser, test_step_executions: :test_step], test_version: [:test, :test_steps])
                           .latest.page(params[:page]).per(20)
        set_pagination_header @test_executions
      end

      def create
        @test_version = Test.find(params[:test_id]).test_versions.find_by!(position: params[:number])
        authorize @test_version, :show?
        @test_execution = @test_version.test_executions.with_user(current_user).build
        authorize @test_execution

        if @test_execution.save
          @test_execution.execute_async!(current_user)
          render :show, status: :created
        else
          render body: { messages: @test_execution.errors.full_messages }.to_json, status: :unprocessable_entity
        end
      end

      def show
        @test_execution = TestExecution.includes(test_execution_browsers: [:browser, test_step_executions: :test_step], test_version: [:test, :test_steps]).find(params[:id])
        authorize @test_execution

        @test_version = @test_execution.test_version
      end
    end
  end
end

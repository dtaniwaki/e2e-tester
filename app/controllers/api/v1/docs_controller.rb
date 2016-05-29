module Api
  module V1
    class DocsController < Api::BaseController
      swagger_root do
        key :swagger, '2.0'
        info do
          key :version, '1.0.0.beta1'
          key :title, Settings.application.api.name
          key :description, Settings.application.api.desc
          contact do
            key :name, 'dtaniwaki'
          end
          license do
            key :name, 'MIT'
          end
        end
        key :host, Settings.application.api.url_options.host
        key :basePath, '/api/v1'
        key :consumes, ['application/json']
        key :produces, ['application/json']
        security_definition 'Bearer' do
          key :type, :apiKey
          key :name, :Authorization
          key :in, :header
        end
        tag do
          key :name, 'test_executions'
          key :description, 'Test executions'
        end
      end

      # A list of all classes that have swagger_* declarations.
      SWAGGERED_CLASSES = [
        TestExecutionsController,
        self
      ].freeze

      def index
        revision = begin
                     File.read(Rails.root.join('REVISION'))
                   rescue
                     Time.zone.now.to_s
                   end
        json = Rails.cache.fetch("swagger-api-v1-docs-#{revision}") do
          Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
        end
        render body: json.to_json
      end
    end
  end
end

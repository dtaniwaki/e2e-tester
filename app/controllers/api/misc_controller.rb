module Api
  class MiscController < BaseController
    def not_found
      raise 'Not found'
    end
  end
end

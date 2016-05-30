module Api
  class MiscController < BaseController
    def not_found
      raise E2eTester::NotFound
    end
  end
end

module E2eTester
  class Exception < ::StandardError
  end

  class NotAuthenticated < Exception
    def initialize(message = 'Not authenticated')
      @message = 'Not authenticated'
      super
    end
  end
end

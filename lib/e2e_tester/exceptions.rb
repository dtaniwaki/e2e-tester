module E2eTester
  class Exception < ::StandardError
  end

  class NotAuthenticated < Exception
  end

  class NotFound < Exception
  end

  class GenerateTokenFailure < Exception
  end

  class JavaScriptError < Exception
  end
end

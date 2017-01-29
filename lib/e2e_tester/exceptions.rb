module E2eTester
  class Exception < ::StandardError
  end

  class NotAuthenticated < RuntimeError
  end

  class NotFound < RuntimeError
  end

  class GenerateTokenFailure < RuntimeError
  end

  class JavaScriptError < RuntimeError
  end
end

module Users
  class SessionsController < Devise::SessionsController
    layout 'public'
  end
end

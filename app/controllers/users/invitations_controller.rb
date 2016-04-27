module Users
  class InvitationsController < Devise::InvitationsController
    before_action :configure_permitted_parameters

    private

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:accept_invitation).concat [:name]
    end
  end
end

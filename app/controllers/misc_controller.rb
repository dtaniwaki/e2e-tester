class MiscController < ApplicationController
  skip_after_action :verify_authorized

  def root
  end
end

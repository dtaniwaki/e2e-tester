class BaseController < ApplicationController
  include Pundit
  include PunditExt
  include OriginConcern
  include LocaleConcern
  include UrlHelper
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  before_action :authenticate_user!
  before_action :set_locale
end

module OriginConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_origin
    helper_method :origin
  end

  def set_origin
    session[:origin] = params[:origin] if params[:origin].present?
  end

  def origin
    return @origin if @origin.present?
    url = params[:origin] || session[:origin]
    return if url.nil?
    url = URI.parse(url)
    # Only allow redirection to the same scheme/host to avoid open redirection
    @origin ||= url.host == request.host && url.scheme == request.scheme ? url.to_s : nil
  end
end

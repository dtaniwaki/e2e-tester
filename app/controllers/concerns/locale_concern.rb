module LocaleConcern
  def set_locale
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
    logger.debug "* Locale set to '#{I18n.locale}'"
  end

  private

  def extract_locale_from_accept_language_header
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(/^[a-z]{2}/).first
  end
end

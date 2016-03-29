class UrlValidator < ::ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.is_a?(String)
      uri = URI(value)
      # The following validation is not necessary as of Ruby 2.2.0
      raise URI::InvalidURIError, "bad URI(is not URI?): #{value}" if value.include?(' ')

      return record.errors[attribute] << i18n_message(record, attribute, :contain_hash, "can't contain hashes(#)") if options[:no_hash] && value.include?('#')

      if uri.host.nil? || !(uri.is_a?(URI::HTTPS) || uri.is_a?(URI::HTTP))
        return record.errors[attribute] << i18n_message(record, attribute, :invalid_format, 'is invalid format')
      end
    else
      record.errors[attribute] << i18n_message(record, attribute, :invalid_format, 'is invalid format')
    end
  rescue URI::InvalidURIError
    record.errors[attribute] << i18n_message(record, attribute, :invalid_format, 'is invalid format')
  end

  private

  def i18n_message(record, attribute, type, default)
    record.errors.generate_message(attribute, type, raise: true)
  rescue I18n::MissingTranslationData
    default
  end
end

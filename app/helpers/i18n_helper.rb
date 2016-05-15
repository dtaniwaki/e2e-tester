module I18nHelper
  def translate(key, options = {})
    options = options.dup
    options[:raise] = true
    if key.to_s !~ /^(devise|simple_form|activerecord|models)/
      options[:scope] = ['views']
    end
    super(key, options)
  rescue I18n::MissingTranslationData => e
    options.key?(:default) ? options[:default] : e.keys.join('.')
  end
  alias t translate
end

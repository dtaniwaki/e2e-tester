base = Settings.secret_key_base
if base.present?
  Rails.application.config.secret_key_base = base
elsif Rails.env.development? || Rails.env.test?
  Rails.application.config.secret_key_base = ('x' * 30)
end

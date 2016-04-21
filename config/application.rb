require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module E2eTester
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.eager_load_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('lib', 'validators')
    config.generators do |g|
      g.test_framework :rspec
      g.javascript_engine :js
      g.helper false
      g.decorator false
    end
    config.active_job.queue_adapter = :sidekiq

    # Workaround for https://github.com/plataformatec/devise/issues/3643
    config.relative_url_root ||= '/'

    # Need to set loggers before initialize
    {
      default: config,
      active_record: config.active_record,
      action_controller: config.action_controller,
      action_mailer: config.action_mailer,
      bugsnag: Bugsnag.configuration
    }.each do |name, target|
      settings = Settings.logger[name]
      prefix = name == :default ? '' : "#{name}."
      file = if settings && settings.io_type.casecmp('stdout') == 0
        STDOUT
      elsif settings && settings.io_type.casecmp('stderr') == 0
        STDERR
      else
        Rails.root.join('log', "#{prefix}#{Rails.env}.log")
      end
      logger = ActiveSupport::Logger.new(file)
      logger.level = settings.level if settings && settings.level
      case Settings.logger.format.to_sym
      when :detail
        require 'detail_formatter'
        logger.formatter = DetailFormatter.new(color: Settings.logger.color)
      else
        logger.formatter = ActiveSupport::Logger::SimpleFormatter.new
      end
      target.logger = logger
    end
    Rails.application.config.colorize_logging = Settings.logger.color

    case Settings.mailer.type
    when 'mandrill'
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
        user_name: Settings.mandrill.username,
        password: Settings.mandrill.api_key,
        address: 'smtp.mandrillapp.com',
        enable_starttls_auto: true,
        authentication: 'login',
        port: 587
      }
    when 'mailgun'
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
        user_name: Settings.mailgun.username,
        password: Settings.mailgun.password,
        address: 'smtp.mailgun.org',
        enable_starttls_auto: true,
        authentication: 'login',
        port: 587
      }
    when 'letter_opener', 'letter_opener_web'
      config.action_mailer.delivery_method = Settings.mailer.type.to_sym
    else
      config.action_mailer.delivery_method = :file
    end
  end
end

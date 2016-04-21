class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailer.sender.default
  default_url_options[:host] = Settings.application.host
  default_url_options[:protocol] = Settings.application.protocol

  layout 'mailer'
end

class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailer.sender.default
  default_url_options[:host] = Settings.service.host
  default_url_options[:protocol] = Settings.service.protocol

  layout 'mailer'
end

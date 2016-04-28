class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailer.sender.default
  self.default_url_options =  Settings.application.url_options.to_h

  layout 'mailer'
end

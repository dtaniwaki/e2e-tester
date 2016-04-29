module Browser
  class Browserstack < Base
    validates :os, :os_version, presence: true

    def self.update_source
      browsers = if Settings.browserstack.username.present? && Settings.browserstack.password.present?
        client = ::Browserstack::Automate::Client.new(username: Settings.browserstack.username, password: Settings.browserstack.password)
        client.browsers
      end
      browsers || []
    end

    def self.available_for?(user)
      Settings.application.misc.use_global_browserstack_credential || user.browserstack_credential.present?
    end

    def name
      super.presence || device.presence || "#{browser} #{browser_version}"
    end

    def full_name
      ['Browserstack', os, os_version, browser, browser_version, device].compact.join(' ')
    end

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def driver(credential = nil)
      caps = Selenium::WebDriver::Remote::Capabilities.new
      caps['device']          = device          if device.present?
      caps['browser']         = browser         if browser.present?
      caps['browser_version'] = browser_version if browser_version.present?
      caps['os']              = os              if os.present?
      caps['os_version']      = os_version      if os_version.present?
      caps['name']            = name            if name.present?
      caps['browserstack.debug'] = true

      caps.javascript_enabled = true
      caps.css_selectors_enabled = true
      caps.takes_screenshot = true

      if credential
        username = credential.username
        password = credential.password
      elsif Settings.application.misc.use_global_browserstack_credential && Settings.browserstack.username.present?
        username = Settings.browserstack.username
        password = Settings.browserstack.password
      else
        raise 'You need to set up a crendetial'
      end
      url = "http://#{username}:#{password}@hub.browserstack.com/wd/hub"
      driver = Selenium::WebDriver.for :remote, url: url, desired_capabilities: caps

      at_exit do
        begin
          driver.quit
        rescue
          nil
        end if driver
      end

      driver
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  end
end

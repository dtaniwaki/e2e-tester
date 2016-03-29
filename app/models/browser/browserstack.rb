module Browser
  class Browserstack < Base
    validates :os, :os_version, presence: true

    def self.update_source
      client = ::Browserstack::Automate::Client.new(Settings.browserstack.to_hash)
      client.browsers
    end

    def name
      super.presence || device.presence || "#{browser} #{browser_version}"
    end

    def driver
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

      url = "http://#{Settings.browserstack.username}:#{Settings.browserstack.password}@hub.browserstack.com/wd/hub"
      driver = Selenium::WebDriver.for :remote, url: url, desired_capabilities: caps
      driver.manage.window.maximize

      at_exit do
        begin
          driver.quit
        rescue
          nil
        end if driver
      end

      driver
    end
  end
end

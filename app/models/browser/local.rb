module Browser
  class Local < Base
    validates :browser, presence: true

    def self.update_source
      browsers = [
        {
          browser: 'phantomjs',
          device: 'desktop'
        },
        {
          browser: 'phantomjs',
          device: 'mobile'
        }
      ]
      begin
        browsers << { browser: 'firefox' } if Selenium::WebDriver::Firefox::Binary.path && File.exist?(Selenium::WebDriver::Firefox::Binary.path)
      rescue
        nil
      end
      begin
        browsers << { browser: 'chrome' } if Selenium::WebDriver::Chrome.path && File.exist?(Selenium::WebDriver::Chrome.path)
      rescue
        nil
      end
      begin
        browsers << { browser: 'safari' } if Selenium::WebDriver::Safari.path && File.exist?(Selenium::WebDriver::Safari.path)
      rescue
        nil
      end
      browsers
    end

    def name
      name = super.presence
      return name if name.present?
      s = browser
      s += " (#{device})" if device
      s
    end

    def full_name
      "Local #{name}"
    end

    def driver(_credential = nil)
      browser_name = browser.to_sym
      caps = {}
      case browser_name
      when :phantomjs
        caps = { args: ['--ignore-ssl-errors=yes', '--ssl-protocol=any'] }

        if device == 'mobile'
          caps[:desired_capabilities] = {
            'phantomjs.page.settings.userAgent' =>
              'Mozilla/5.0 (iPhone; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53'
          }
        end
      end

      driver = Selenium::WebDriver.for browser_name, caps

      case browser_name
      when :phantomjs
        driver.manage.window.resize_to(640, 960) if device == 'mobile'
      end

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

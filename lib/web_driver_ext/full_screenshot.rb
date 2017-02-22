module WebDriverExt
  module FullScreenshot
    def take_full_screenshot(driver)
      tempfiles = []
      MiniMagick.logger.level = Logger::DEBUG
      # Webdriver doesn't support full screenshot, so implement it by myself
      append_file_paths = []
      screen_width = driver.execute_script('return window.screen.width').to_i
      screen_height = driver.execute_script('return window.screen.height').to_i
      inner_width = driver.execute_script('return window.innerWidth').to_i
      inner_height = driver.execute_script('return window.innerHeight').to_i
      total_width = driver.execute_script('return document.documentElement.scrollWidth').to_i
      total_height = driver.execute_script('return document.documentElement.scrollHeight').to_i

      slices = inner_height.positive? ? (total_height.to_f / inner_height).ceil : 1

      slices.times do |n|
        tempfiles << (tempfile = Tempfile.new(['screenshot', '.png']))
        driver.execute_script("window.scrollTo(0, #{n * inner_height})")
        # scroll_top = driver.execute_script("window.document.body.scrollTop").to_i
        scroll_top = driver.execute_script('return window.scrollY').to_i
        driver.save_screenshot(tempfile.path)
        tempfile.flush
        # Reset canvas geometry
        MiniMagick::Tool::Mogrify.new do |mog|
          # rubocop:disable Void
          mog.repage.+
          # rubocop:enable Void
          mog << tempfile.path
        end
        image = MiniMagick::Image.new(tempfile.path)
        (image_width, image_height) = image.dimensions
        @logger&.info "n: #{n}, screen: (#{screen_width}, #{screen_height}), total (#{total_width}, #{total_height}), inner (#{inner_width}, #{inner_height}),\
          image (#{image_width}, #{image_height}), scroll (#{scroll_top}, 0)"
        # Resize to actual pixel size
        if total_height <= image_height
          append_file_paths << image.path
          break
        else
          image.resize "#{screen_width}x#{screen_height}" # Align the pixel size
          # Trim outer height part
          real_height = inner_height - (n * inner_height - scroll_top)
          break if real_height <= 0
          if real_height < inner_height
            image.crop "#{screen_width}x#{real_height}+0+#{inner_height - real_height}"
          end
          append_file_paths << image.path
        end
      end

      out_file = Tempfile.new(['out_file', '.png'])
      # Append all the images
      append_file_paths << out_file.path
      MiniMagick::Tool::Convert.new do |convert|
        convert.append
        append_file_paths.each do |path|
          convert << path
        end
      end

      # Reset the scroll
      driver.execute_script('window.scrollTo(0, 0)')

      out_file.flush
      out_file
    ensure
      tempfiles.each(&:close!)
    end
  end
end

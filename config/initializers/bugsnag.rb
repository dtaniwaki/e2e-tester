if defined? Bugsnag
  Bugsnag.configure do |config|
    config.api_key = Settings.bugsnag.api_key
    config.use_ssl = true
    config.release_stage = Rails.env.to_s
    config.project_root = Rails.root.to_s
    config.notify_release_stages = Settings.bugsnag.release_stages

    revision_file_path = Rails.root.join('REVISION')
    if File.exist?(revision_file_path)
      config.app_version = File.read(revision_file_path)
    end

    config.params_filters << 'email'
  end
end

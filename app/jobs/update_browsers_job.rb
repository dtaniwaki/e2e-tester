class UpdateBrowsersJob < ApplicationJob
  include Sidekiq::Worker

  sidekiq_options queue: :low, retry: false, backtrace: true

  def perform(targets = %w(browserstack local))
    targets = targets.map(&:to_s)
    Browser::Browserstack.update_all! if targets.include?('browserstack')
    Browser::Local.update_all! if targets.include?('local')
  end
end

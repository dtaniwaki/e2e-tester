module Browser
  class Base < ApplicationRecord
    self.table_name = 'browsers'

    has_many :test_browsers, inverse_of: :browser
    has_many :browser_browser_sets, inverse_of: :browser, foreign_key: 'browser_id'
    has_many :browser_sets, through: :browser_browser_sets

    scope :active, -> { where(disabled: false, deprecated: false) }
    scope :inactive, -> { where(disabled: true).or(where(deprecated: true)) }

    def self.update_source
      raise NotImplementedError
    end

    def self.update_all!
      ids = []
      update_source.each do |params|
        browser = find_by(params)
        if browser.present?
          browser.update_attributes!(deprecated: false)
          logger.info "Enable existing browser: #{browser.name.inspect}"
        else
          browser = create!(params)
          logger.info "Create a browser: #{browser.name.inspect}"
        end
        ids << browser.id
      end
      find_each do |browser|
        next if ids.include?(browser.id)
        logger.info "Disable the browser: #{browser.name.inspect}"
        browser.update_attributes!(deprecated: true)
      end
    end

    def self.available_for?(_user)
      true
    end

    def browser_type
      type&.demodulize&.underscore
    end

    def full_name
      name
    end

    def driver(_credential = nil)
      raise NotImplementedError
    end
  end
end

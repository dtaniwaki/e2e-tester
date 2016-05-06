class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  nilify_blanks before: :validation
  acts_as_hashids secret: -> { "#{base_class.name} #{Settings.application.misc.hashids_secret}" }, length: 8
end

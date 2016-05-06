class ApplicationRecord < ActiveRecord::Base
  include HashidsExt

  self.abstract_class = true
  nilify_blanks before: :validation
end

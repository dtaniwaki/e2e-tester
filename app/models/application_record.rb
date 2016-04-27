class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  nilify_blanks before: :validation
end

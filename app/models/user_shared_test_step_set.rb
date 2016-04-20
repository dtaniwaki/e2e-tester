class UserSharedTestStepSet < ApplicationRecord
  belongs_to :user, inverse_of: :user_shared_test_step_sets
  belongs_to :shared_test_step_set, inverse_of: :user_shared_test_step_sets
end

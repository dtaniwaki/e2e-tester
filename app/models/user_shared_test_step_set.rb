class UserSharedTestStepSet < ApplicationRecord
  belongs_to :user, inverse_of: :user_shared_test_step_sets
  belongs_to :shared_test_step_set, inverse_of: :user_shared_test_step_sets

  scope :with_user, ->(user) { where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user) }
  scope :with_share_test_step_set, ->(stss) { where(shared_test_step_set_id: stss.is_a?(ActiveRecord::Base) ? stss.id : stss) }
end

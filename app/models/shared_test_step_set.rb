class SharedTestStepSet < TestStepSet
  has_many :user_shared_test_step_sets, inverse_of: :shared_test_step_set
end

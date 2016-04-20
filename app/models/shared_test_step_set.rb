class SharedTestStepSet < TestStepSet
  has_many :user_shared_test_step_sets, inverse_of: :shared_test_step_set

  after_create :assign_owner!

  private

  def assign_owner!
    user_shared_test_step_sets.create!(user: user)
  end
end

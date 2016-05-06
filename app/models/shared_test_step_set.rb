class SharedTestStepSet < TestStepSet
  has_many :user_shared_test_step_sets, inverse_of: :shared_test_step_set
  has_many :referred_test_steps, class_name: 'TestStep::StepSet', inverse_of: :shared_test_step_set

  after_create :assign_owner!

  validates :title, uniqueness: { scope: [:user_id, :type] }, presence: true
  validates :test_steps, presence: true

  private

  def assign_owner!
    user_shared_test_step_sets.create!(user: user)
  end
end

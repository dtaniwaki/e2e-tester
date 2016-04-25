module TestStep
  def self.steps
    # Manually assign the classes to avoid multi threaded requiring
    @stesp ||= [
      TestStep::None,
      TestStep::Navigation,
      TestStep::Screenshot,
      TestStep::PageSource,
      TestStep::Wait,
      TestStep::ResizeWindow,
      TestStep::MaximizeWindow,
      TestStep::Fill,
      TestStep::Click,
      TestStep::Eval,
      TestStep::StepSet
    ].freeze
  end
end

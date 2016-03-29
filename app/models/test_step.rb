module TestStep
  def self.from_line(line)
    steps.map { |ts| ts.from_line(line) }.compact[0]
  end

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
      TestStep::Eval
    ].freeze
  end
end

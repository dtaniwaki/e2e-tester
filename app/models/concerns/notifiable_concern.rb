module NotifiableConcern
  def notify!(_name, *_args)
    raise NotImplementedError
  end

  def notify?(_name, _user_test = nil)
    raise NotImplementedError
  end
end

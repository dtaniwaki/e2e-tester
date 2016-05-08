class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user = nil, record = nil)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope, :context

    def initialize(user = nil, scope = nil, context = nil)
      @user = user
      @scope = scope
      @context = context
    end

    def resolve
      scope
    end
  end
end

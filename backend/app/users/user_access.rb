class UserAccess
  def initialize(actor, target)
    @actor = actor
    @target = target
  end

  def allowed?
    actor.id == target.id
  end

  private

  attr_reader :actor, :target
end

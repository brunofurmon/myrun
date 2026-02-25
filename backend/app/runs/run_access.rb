class RunAccess
  def initialize(actor, run)
    @actor = actor
    @run = run
  end

  def allowed?
    return true if run.user_id == actor.id
    return true if run.public
          
    false
  end

  private

  attr_reader :actor, :run
end
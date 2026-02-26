class RunAccess
  def initialize(actor, run)
    @actor = actor
    @run = run
  end

  def allowed?
    return true if run.user_id == actor.id
    return false if run.only_me?
    return true if run.open?
    return true if friends?

    false
  end

  private

  attr_reader :actor, :run

  def friends?
    Follow.exists?(
      follower_id: actor.id,
      followee_id: run.user_id,
      status: :accepted
    )
  end
end
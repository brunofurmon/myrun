class FollowAccess
  def initialize(actor, follow)
    @actor = actor
    @follow = follow
  end

  def request?
    actor.id == follow.follower_id
  end

  def approve?
    actor.id == follow.followee_id
  end

  private

  attr_reader :actor, :follow
end
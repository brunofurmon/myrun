class RunFeed
  def initialize(actor)
    @actor = actor
  end

  def visible_runs
    Run
      .left_joins(:user)
      .where(visibility_sql)
      .order(started_at: :desc)
  end

  private 

  attr_reader :actor

  def visibility_sql
    [
      <<~SQL,
        runs.user_id = :actor_id
        OR runs.privacy = :open
        OR (
          runs.privacy = :friends
          AND EXISTS (
            SELECT 1
            FROM follows
            WHERE follows.follower_id = :actor_id
            AND follows.followee_id = runs.user_id
            AND follows.status = :accepted
          )
        )
      SQL
      {
        actor_id: actor.id,
        open: Run.privacies[:open],
        friends: Run.privacies[:friends],
        accepted: Follow.statuses[:accepted]
      }
    ]
  end
end
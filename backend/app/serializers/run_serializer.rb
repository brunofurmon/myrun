class RunSerializer
  def initialize(run)
    @run = run
  end

  def as_json(*)
    {
      id: run.id,
      user_id: run.user_id,
      start: { lat: run.start_lat, lng: run.start_lng },
      end:   { lat: run.end_lat, lng: run.end_lng },
      started_at: run.started_at,
      ended_at: run.ended_at,
      avg_heartbeat: run.avg_heartbeat,
      calories: run.calories,
      privacy: run.privacy
    }
  end

  private

  attr_reader :run
end
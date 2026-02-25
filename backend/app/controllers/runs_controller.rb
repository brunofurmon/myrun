class RunsController < ApplicationController
  before_action :authenticate_user!

  def create
    run = current_user.runs.build(run_params)
    authorize run, :create?

    run.save!
    render json: RunSerializer.new(run), status: :created
  end

  def show
    run = Run.find(params[:id])
    authorize run, :show?

    render json: RunSerializer.new(run)
  end

  private

  def run_params
    params.require(:run).permit(
      :start_lat,
      :start_lng,
      :end_lat,
      :end_lng,
      :started_at,
      :ended_at,
      :avg_heartbeat,
      :calories,
      :privacy
    )
  end
end
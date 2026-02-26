class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    follow = Follow.new(
      follower_id: current_user.id,
      followee_id: params[:followee_id],
      status: :pending
    )

    authorize follow, :create?
    follow.save!

    render json: { status: "pending" }, status: :created
  end

  def approve
    follow = Follow.find(params[:id])
    authorize follow, :approve?

    follow.update(status: :accepted)

    render json: { status: "accepted" }
  end
end
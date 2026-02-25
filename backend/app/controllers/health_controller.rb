class HealthController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize current_user, :show?
    render json: { status: "ok", user_id: @current_user.id }
  end
end
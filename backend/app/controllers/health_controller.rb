class HealthController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: { status: "ok", user_id: @current_user.id }
  end
end
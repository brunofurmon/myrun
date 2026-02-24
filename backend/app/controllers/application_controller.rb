class ApplicationController < ActionController::API
  private

  def authenticate_user!
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    payload = JwtService.decode(token)
    return render json: { error: "Unauthorized" }, status: :unauthorized unless payload

    @current_user = User.find_by(id: payload["user_id"])
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end

class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do
    render json: { error: "Forbidden" }, status: "forbidden"  
  end

  private

  def authenticate_user!
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    payload = JwtService.decode(token)
    return render json: { error: "Unauthorized" }, status: :unauthorized unless payload

    @current_user = User.find_by(id: payload["user_id"])
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end

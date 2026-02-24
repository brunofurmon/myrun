class AuthenticationController < ApplicationController
  def login
    user = User.find_for_database_authentication(email: params[:email])
    unless user&.valid_password?(params[:password])
      return render json: { error: "Invalid credentials" }, status: :unauthorized
    end

    token = JwtService.encode({user_id: user.id})

    render json: { token: }
  end
end
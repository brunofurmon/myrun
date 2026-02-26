module AuthHelper
  def auth_header_for(user)
    token = JwtService.encode({ user_id: user.id })
    { "Authorization" => "Bearer #{token}" }
  end
end
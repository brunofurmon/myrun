class JwtService
  SECRET = Rails.application.secret_key_base
  ALGORITHM = "HS256"

  def self.encode(payload, exp: 24.hours.from_now)
    payload = payload.merge(exp: exp.to_i)
    JWT.encode(payload, SECRET, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET, true, algorithm: ALGORITHM)
    decoded.first
  rescue JWT::DecodeError
    nil
  end
end
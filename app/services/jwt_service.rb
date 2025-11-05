class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE'] || 'fallback_secret_key_for_development_use_in_production'

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  rescue => e
    Rails.logger.error "JWT encode error: #{e.message}"
    raise
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    nil
  end
end


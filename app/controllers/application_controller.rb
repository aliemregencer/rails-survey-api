class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    token = extract_token_from_header
    
    if token.blank?
      render json: { error: "Unauthorized - No token provided" }, status: :unauthorized
      return
    end

    decoded_token = JwtService.decode(token)
    
    if decoded_token && decoded_token[:user_id]
      @current_user = User.find_by(id: decoded_token[:user_id])
      
      if @current_user.nil?
        render json: { error: "Unauthorized - Invalid user" }, status: :unauthorized
      end
    else
      render json: { error: "Unauthorized - Invalid token" }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def extract_token_from_header
    auth_header = request.headers['Authorization']
    return nil unless auth_header
    
    # Authorization: Bearer <token> formatından token'ı çıkar
    auth_header.split(' ').last if auth_header.starts_with?('Bearer ')
  end

  def current_user
    @current_user
  end

  def logged_in?
    current_user.present?
  end
end

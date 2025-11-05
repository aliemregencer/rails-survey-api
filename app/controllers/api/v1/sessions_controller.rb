module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]
      
      def create
        email = params[:email]
        password = params[:password]
        
        # Validate input
        if email.blank? || password.blank?
          render json: { error: "Email and password are required" }, status: :unauthorized
          return
        end
        
        # Find user
        user = User.find_by(email: email)
        
        # Check if user exists
        unless user
          render json: { error: "Invalid email or password" }, status: :unauthorized
          return
        end
        
        # Authenticate user
        unless user.authenticate(password)
          render json: { error: "Invalid email or password" }, status: :unauthorized
          return
        end
        
        # Generate JWT token
        begin
          token = JwtService.encode({ user_id: user.id })
          render json: { 
            token: token, 
            user: { id: user.id, email: user.email } 
          }, status: :ok
        rescue => e
          Rails.logger.error "JWT generation failed: #{e.message}"
          render json: { error: "Authentication failed" }, status: :internal_server_error
        end
      end
    end
  end
end


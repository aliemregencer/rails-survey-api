module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]
      
      def create
        user = User.new(user_params)
        
        if user.save
          token = JwtService.encode({ user_id: user.id })
          render json: { 
            token: token, 
            user: { id: user.id, email: user.email },
            message: "User created successfully"
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end


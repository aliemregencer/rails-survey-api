module Api
  module V1
    class ResponsesController < ApplicationController
      # GET /api/v1/responses
      def index
        @responses = Response.all
        render json: { responses: @responses }
      end

      # POST /api/v1/responses
      def create
        @response = Response.new(response_params)
        
        if @response.save
          render json: { response: @response }, status: :created
        else
          render json: { errors: @response.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def response_params
        params.require(:response).permit(:user_id, :survey_id, :question_id, :answer_value)
      end
    end
  end
end


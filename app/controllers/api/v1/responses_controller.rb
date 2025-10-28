module Api
  module V1
    class ResponsesController < ApplicationController
      before_action :set_survey, only: [:create]

      # POST /api/v1/surveys/:survey_id/responses
      # expected payload:
      # {
      #   response: { user_id: 1 },
      #   answers: [ { question_id: 10, content: "A" }, ... ]
      # }
      def create
        response_record = nil
        ActiveRecord::Base.transaction do
          response_record = @survey.responses.create!(user_id: response_params[:user_id])
          answers_attributes.each do |ans|
            response_record.answers.create!(question_id: ans[:question_id], content: ans[:content])
          end
        end

        render json: { response: response_record, answers: response_record.answers }, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      private

      def set_survey
        @survey = Survey.find(params[:survey_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Survey not found" }, status: :not_found
      end

      def response_params
        params.require(:response).permit(:user_id)
      end

      def answers_attributes
        params.fetch(:answers, []).map do |a|
          a.permit(:question_id, :content)
        end
      end
    end
  end
end


module Api
  module V1
    class QuestionsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:index]
      before_action :set_survey, only: [:index, :create]
      before_action :set_question, only: [:update, :destroy]

      # GET /api/v1/surveys/:survey_id/questions
      def index
        questions = @survey.questions
        render json: { questions: questions }
      end

      # POST /api/v1/surveys/:survey_id/questions
      def create
        question = @survey.questions.build(question_params)
        if question.save
          render json: { question: question }, status: :created
        else
          render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/questions/:id
      def update
        if @question.update(question_params)
          render json: { question: @question }
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/questions/:id
      def destroy
        @question.destroy
        head :no_content
      end

      private

      def set_survey
        @survey = Survey.find(params[:survey_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Survey not found" }, status: :not_found
      end

      def set_question
        @question = Question.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Question not found" }, status: :not_found
      end

      def question_params
        params.require(:question).permit(:title, :question_type, :required)
      end
    end
  end
end


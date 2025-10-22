module Api
  module V1
    class QuestionsController < ApplicationController
      # GET /api/v1/questions
      def index
        @questions = Question.all
        render json: { questions: @questions }
      end

      # GET /api/v1/questions/:id
      def show
        @question = Question.find(params[:id])
        render json: { question: @question }
      end
    end
  end
end


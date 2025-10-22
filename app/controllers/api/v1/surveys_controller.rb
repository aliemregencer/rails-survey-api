module Api
  module V1
    class SurveysController < ApplicationController
      # GET /api/v1/surveys
      def index
        @surveys = Survey.all
        render json: { surveys: @surveys }
      end

      # GET /api/v1/surveys/:id
      def show
        @survey = Survey.find(params[:id])
        render json: { survey: @survey }
      end

      # POST /api/v1/surveys
      def create
        @survey = Survey.new(survey_params)
        
        if @survey.save
          render json: { survey: @survey }, status: :created
        else
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/surveys/:id
      def update
        @survey = Survey.find(params[:id])
        
        if @survey.update(survey_params)
          render json: { survey: @survey }
        else
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/surveys/:id
      def destroy
        @survey = Survey.find(params[:id])
        @survey.destroy
        
        render json: { message: "Survey deleted successfully" }, status: :ok
      end

      private

      def survey_params
        params.require(:survey).permit(:user_id, :title, :description, :status)
      end
    end
  end
end


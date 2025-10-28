module Api
  module V1
    class SurveysController < ApplicationController
      before_action :set_survey, only: [:show, :update, :destroy, :publish, :unpublish, :pause, :archive]

      # GET /api/v1/surveys
      def index
        @surveys = Survey.all
        render json: { surveys: @surveys }
      end

      # GET /api/v1/surveys/:id
      def show
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
        if @survey.update(survey_params)
          render json: { survey: @survey }
        else
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/surveys/:id
      def destroy
        @survey.destroy
        render json: { message: "Survey deleted successfully" }, status: :ok
      end

      # PUT /api/v1/surveys/:id/publish
      def publish
        if @survey.update(status: :published, published_at: Time.current)
          render json: { 
            survey: @survey, 
            message: "Survey published successfully" 
          }, status: :ok
        else
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/surveys/:id/unpublish
      def unpublish
        if @survey.update(status: :draft, unpublished_at: Time.current)
          render json: { 
            survey: @survey, 
            message: "Survey unpublished successfully" 
          }, status: :ok
        else
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/surveys/:id/pause
      def pause
        if @survey.update(status: :paused)
          render json: { 
            survey: @survey, 
            message: "Survey paused successfully" 
          }, status: :ok
        else
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/surveys/:id/archive
      def archive
        if @survey.update(status: :archived)
          render json: { 
            survey: @survey, 
            message: "Survey archived successfully" 
          }, status: :ok
        else
          render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_survey
        @survey = Survey.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Survey not found" }, status: :not_found
      end

      def survey_params
        params.require(:survey).permit(:user_id, :title, :description, :status)
      end
    end
  end
end


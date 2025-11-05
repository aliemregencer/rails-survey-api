class Api::HealthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  def index
    render json: { status: 'ok', message: 'API is running' }
  end
end

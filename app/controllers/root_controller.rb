class RootController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  def index
    render json: { error: "Not Found" }, status: :not_found
  end
end

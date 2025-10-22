class RootController < ApplicationController
  def index
    render json: { error: "Not Found" }, status: :not_found
  end
end

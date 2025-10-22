# config/routes.rb

Rails.application.routes.draw do
  # Root route - API-only projelerde 404 döndürür
  root 'root#index'
  namespace :api do
    get "health", to: "health#index"
    
    namespace :v1 do
      resources :surveys
      resources :questions, only: [:index, :show]
      resources :responses, only: [:create, :index]
    end
  end

end
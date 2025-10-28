# config/routes.rb

Rails.application.routes.draw do
  # Root route - API-only projelerde 404 döndürür
  root 'root#index'
  namespace :api do
    get "health", to: "health#index"
    
    namespace :v1 do
      resources :surveys do
        member do
          put :publish
          put :unpublish
          put :pause
          put :archive
        end
        resources :questions, only: [:index, :create], controller: "api/v1/questions"
        resources :responses, only: [:create], controller: "api/v1/responses"
      end
      resources :questions, only: [:update, :destroy]
    end
  end

end
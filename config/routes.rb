# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Root route for frontend
  root 'application#index', defaults: { format: 'html' }

  namespace :api do
    get 'users/:id/balance', to: 'users#balance'
    get 'rewards', to: 'rewards#index'
    
    resources :users, only: [] do
      resources :redemptions, only: [:index, :create]
    end
  end

  # Catch-all route for frontend pages (must be last)
  get '*path', to: 'application#index', constraints: lambda { |req|
    !req.path.start_with?('/api')
  }, defaults: { format: 'html' }
end

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  post "/login", to: "authentication#login"
  get "/health", to: "health#show"
  
  get "/users/:id", to: "users#show"

  get "/runs", to: "runs#index"
  get "/runs/:id", to: "runs#show"
  post "/runs", to: "runs#create"

  post "follows", to: "follows#create"
  post "follows/:id/approve", to: "follows#approve"
end

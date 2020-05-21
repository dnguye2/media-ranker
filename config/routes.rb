Rails.application.routes.draw do  
  # Homepage
  root to: "pages#index"
  
  # Works
  resources :works

  # Users
  resources :users, only: [:show, :index]
  get "/login", to: "users#login_form", as: "login"
  post "/login", to: "users#login"
  post "/logout", to: "users#logout", as: "logout"
  get "/users/current", to: "users#current", as: "current_user"

  # Votes
  resources :votes, only: [:create]
end

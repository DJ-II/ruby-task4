Rails.application.routes.draw do
  root "sessions#new"

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  get "/register", to: "registrations#new", as: :register
  post "/register", to: "registrations#create"

  get "/users", to: "users#index", as: :users
  post "/users/bulk", to: "users#bulk", as: :bulk_users
end

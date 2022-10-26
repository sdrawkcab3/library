Rails.application.routes.draw do
  get 'scan/new'
  resources :books
  resources :loans
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :reviews
  get "about", to: "pages#about"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  root to: "books#index"

end

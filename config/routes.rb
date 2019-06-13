Rails.application.routes.draw do
  root 'todos#index'  
  resources :todos

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }
end

Rails.application.routes.draw do
  namespace :users do
    get 'contents/index'
    get 'contents/show'
  end

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords:     'users/passwords',
    registrations: 'users/registrations',
    sessions:      'users/sessions',
    unlocks:       'users/unlocks',
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  root 'static_pages#top'

  # resources :users
  
end

Rails.application.routes.draw do

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords:     'users/passwords',
    registrations: 'users/registrations',
    sessions:      'users/sessions',
    unlocks:       'users/unlocks',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  namespace :users do
    get 'contents/index'
    get 'contents/show'
  end
  
  namespace :events do
    get 'new_a'
    get 'new_b'
  end
  resources :events do
    member do
      post 'import'
      delete 'destroy_members_and_schedules'
      patch 'update_decision_of_schedule'
      patch 'update_chouseisan_check'
    end
#    collection { post :import }
  end
  
  root 'static_pages#top'
end

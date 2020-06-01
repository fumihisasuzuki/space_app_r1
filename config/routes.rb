Rails.application.routes.draw do
  get 'fees/edit'

  get 'invitations/edit'

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
    get 'contents/past_events_list'
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
      get 'the_day'
      patch 'finish'
      get 'invitations/edit'
      patch 'invitations/update'
      post 'fees/create'
      patch 'fees/update'
    end
    patch 'members/update_all'
    resources :members do
      member do
        patch 'update_status'
      end
    end
    resources :shops do
      member do
        patch 'update_decision'
      end
    end
  end
  
  root 'static_pages#top'
end

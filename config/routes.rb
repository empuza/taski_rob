Rails.application.routes.draw do
  root to: 'api/tasks#index'

  post 'signup', controller: :signup, action: :create
  post 'signin', controller: :signin, action: :create
  delete 'signin', controller: :signin, action: :destroy
  post 'refresh', controller: :refresh, action: :create
  get 'me', controller: :users, action: :me
  patch 'change_password', controller: :password_changes, action: :update

  resources :users, only: %i[update]

  namespace :api do
    resources :tasks, only: %i[index create update destroy]
  end

  resources :password_resets, only: [:create] do
    collection do
      get ':token', action: :edit, as: :edit
      patch ':token', action: :update
    end
  end

  resources :activation, only: [:create] do
    collection do
      patch ':token', action: :update
    end
  end

  namespace :admin do
    resources :users, only: %i[index show update] do
      resources :tasks, only: %i[index], controller: 'users/tasks'
    end
  end
end

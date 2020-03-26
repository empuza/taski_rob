Rails.application.routes.draw do
  root to: 'api/tasks#index'

  post 'signup', controller: :signup, action: :create
  post 'signin', controller: :signin, action: :create
  delete 'signin', controller: :signin, action: :destroy
  post 'refresh', controller: :refresh, action: :create

  namespace :api do
    resources :tasks, only: %i[index create update destroy]
  end
end

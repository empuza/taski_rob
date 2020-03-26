Rails.application.routes.draw do
  get 'refresh/create'
  post 'signup', controller: :signup, action: :create
  post 'signin', controller: :signin, action: :create
  post 'refresh', controller: :refresh, action: :create
end

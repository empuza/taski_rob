Rails.application.routes.draw do
  post 'signup', controller: :signup, action: :create
  post 'signin', controller: :signin, action: :create
end

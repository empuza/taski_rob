class UsersController < ApplicationController
  before_action :authorize_access_request!

  def me
    render json: current_user.as_json(only: %i[id username email])
  end
end

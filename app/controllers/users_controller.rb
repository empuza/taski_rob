class UsersController < ApplicationController
  before_action :authorize_access_request!

  def update
    if current_user.update(user_params)
      render json: current_user, only: %i[id username email role]
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def me
    render json: current_user
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end

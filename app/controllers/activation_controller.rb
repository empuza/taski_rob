class ActivationController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_activation_token!
      UserMailer.activate_account(user).deliver_now
    end
    render json: :ok
  end

  def update
    user = User.find_by(activation_token: params[:token])
    puts user
    user.update!(activated: true)
    user.clear_activation_token!
    render json: :ok
  end
end

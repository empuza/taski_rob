class PasswordChangesController < ApplicationController
  KEYS = %i[password password_confirmation].freeze

  def update
    user = User.find_by(id: params[:user_id])
    if user&.authenticate(params[:current_password])
      user.update!(password_params)
      render json: :ok
    else
      wrong_current_password
    end
  end

  private

  def password_params
    params.tap { |p| p.require(KEYS) }.permit(*KEYS)
  end

  def wrong_current_password
    render json: { error: 'Current password is wrong. Try again.' },
           status: :not_acceptable
  end
end

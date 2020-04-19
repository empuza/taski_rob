class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user = User.find_by!(email: params[:email])
    if user.authenticate(params[:password]) && user.activated
      payload = { user_id: user.id, aud: [user.role] }
      session = JWTSessions::Session.new(payload: payload,
                                         refresh_by_access_allowed: true,
                                         namespace: "user_#{user.id}")
      tokens = session.login
      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
      render json: { csrf: tokens[:csrf] }
    elsif !user.activated && user.activation_token_expires_at && user.activation_token_expires_at > Time.now
      not_activated_but_token_exists
    elsif !user.activated && user.activation_token_expires_at && user.activation_token_expires_at < Time.now
      clear_and_generate_activation_token(user)
    else
      not_authorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload,
                                       namespace: "user_#{payload['user_id']}")
    session.flush_by_access_payload
    render json: :ok
  end

  private

  def not_found
    render json: { error: 'Cannot find such email/password combination' },
           status: :not_found
  end

  def not_activated_but_token_exists
    render json: { error: 'Account not activated. Please check your email and activate your account.' },
           status: :not_acceptable
  end

  def not_activated_and_token_expired
    render json: { error: 'Account not activated. Account activation link was sent again to your email.' },
           status: :not_acceptable
  end

  def clear_and_generate_activation_token(user)
    user.clear_activation_token!
    user.generate_activation_token!
    UserMailer.activate_account(user).deliver_now
    not_activated_and_token_expired
  end
end

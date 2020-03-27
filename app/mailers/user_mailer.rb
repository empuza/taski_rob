class UserMailer < ApplicationMailer
  def reset_password(user)
    @user = user
    mail(to: @user.email, subject: 'Reset your password')
  end

  def activate_account(user)
    @user = user
    mail(to: @user.email, subject: 'Account activation')
  end
end

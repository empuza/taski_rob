require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'reset password notification' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.reset_password(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Reset your password')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end
  end
end

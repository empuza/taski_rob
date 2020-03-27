require 'rails_helper'

RSpec.describe ActivationController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    it do
      expect(UserMailer).to receive(:activate_account).once.and_return(double(deliver_now: true))
      post :create, params: { email: user.email }
      expect(response).to be_successful
    end

    it do
      expect(UserMailer).to_not receive(:activate_account)
      post :create, params: { email: 'non@existent.com' }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    it do
      user.generate_activation_token!
      patch :update, params: { token: user.activation_token }
      expect(response).to be_successful
    end
  end
end

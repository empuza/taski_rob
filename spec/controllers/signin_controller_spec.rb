require 'rails_helper'

RSpec.describe SigninController, type: :controller do
  describe 'POST #create' do
    let(:password) { 'password' }
    let(:user_params) { { email: user.email, password: password } }

    context 'successful login' do
      let(:user) { create(:activated_user) }
      it 'returns http success' do
        post :create, params: user_params
        expect(response).to have_http_status(:success)
        expect(response_json.keys).to eq ['csrf']
        expect(response.cookies[JWTSessions.access_cookie]).to be_present
      end

      it 'returns unauthorized for invalid params' do
        post :create, params: { email: user.email, password: 'incorrect' }
        expect(response).to have_http_status(401)
      end

      it 'returns not found for not existing user' do
        post :create, params: { email: 'test@test.com', password: 'incorrect' }
        expect(response).to have_http_status(404)
        expect(response_json.first.last).to eq('Cannot find such email/password combination')
      end
    end

    context 'failed because not activated account, but valid token' do
      let(:user) { create(:not_activated_user_with_valid_token) }
      it 'returns 406 when not activated but token exists ' do
        post :create, params: user_params
        expect(response).to have_http_status(406)
        expect(response_json.first.last).to eq('Account not activated. Please check your email and activate your account.')
      end
    end

    context 'failed because not activated account and expired token' do
      let(:user) { create(:not_activated_user_with_expired_token) }
      it 'returns 406 when not activated but token exists ' do
        post :create, params: user_params
        expect(response).to have_http_status(406)
        expect(response_json.first.last).to eq('Account not activated. Account activation link was sent again to your email.')
      end
    end
  end

  describe 'logout DELETE #destroy' do
    let(:user) { create(:activated_user) }
    context 'failure' do
      it 'returns unauthorized http status' do
        delete :destroy
        expect(response).to have_http_status(401)
      end
    end
    context 'success' do
      it 'returns http success with valid tokens' do
        payload = { user_id: user.id }

        session = JWTSessions::Session.new(
          payload: payload,
          refresh_by_access_allowed: true,
          namespace: "user_#{user.id}"
        )

        tokens = session.login
        request.cookies[JWTSessions.access_cookie] = tokens[:access]
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]

        delete :destroy
        expect(response).to have_http_status(200)
        expect(response_json).to eq('ok')
      end
    end
  end
end

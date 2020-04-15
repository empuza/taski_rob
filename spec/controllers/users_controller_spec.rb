require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:invalid_attributes) { { username: '', email: '' } }
  before { sign_in_as(user) }

  before do
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    @tokens = session.login
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:new_attributes) { { username: 'Jane Doe', email: Faker::Internet.email } }
      it 'updates current user details' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        patch :update, params: { id: user.id, user: new_attributes }
        user.reload
        expect(user.username).to eq new_attributes[:username]
        expect(user.email).to eq new_attributes[:email]
      end
      it 'renders a JSON response with the user' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        patch :update, params: { id: user.to_param, user: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the current user' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        patch :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'GET #me' do
    let!(:task) { create(:task, user: user) }

    it 'returns a success response' do
      get :me
      expect(response).to be_successful
      expect(response_json).to eq user.as_json.stringify_keys
    end
  end

end

require 'rails_helper'

RSpec.describe PasswordChangesController, type: :controller do
  let(:user) { create(:user) }

  before do
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    @tokens = session.login
  end

  describe 'PATCH #update' do
    let(:current_password) { 'password' }
    let(:new_password) { 'new_password' }
    it do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
      patch :update, params: { user_id: user.id,
                               current_password: current_password,
                               password: new_password,
                               password_confirmation: new_password }
      expect(response).to have_http_status(:success)
    end

    it 'returns 422 if passwords do not match' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
      patch :update, params: { user_id: user.id,
                               current_password: current_password,
                               password: new_password,
                               password_confirmation: 1 }
      expect(response).to have_http_status(422)
    end

    it 'returns 406 if param is missing' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
      patch :update, params: { user_id: user.id,
                               password: new_password }
      expect(response).to have_http_status(406)
    end
  end
end

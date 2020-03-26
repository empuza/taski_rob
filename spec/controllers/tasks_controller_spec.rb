require 'rails_helper'

RSpec.describe Api::TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { name: 'Task', deadline: '2020-03-25 21:15:34', done: false } }
  let(:valid_attributes_for_update) { { name: 'Task', deadline: '2020-03-25 21:15:34', done: true } }
  let(:invalid_attributes) { { name: nil, deadline: nil, done: nil } }

  before do
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    @tokens = session.login
  end

  describe 'GET #index' do
    let!(:task) { create(:task, user: user) }
    it 'returns a success response' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      get :index
      expect(response).to have_http_status(:success)
      expect(response_json.size).to eq 2
      expect(response_json.first[1].first['id']).to eq task.id
    end

    it 'unauthorized without cookie' do
      get :index
      expect(response).to have_http_status(401)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new task' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        expect { post :create, params: { task: valid_attributes } }.to change(Task, :count).by(1)
      end

      it 'renders a JSON response with the new task' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        post :create, params: { task: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq('/')
      end

      it 'unauthorized without CSRF' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        post :create, params: { task: valid_attributes }
        expect(response).to have_http_status(401)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new task' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        post :create, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    let!(:task) { create(:task, user: user) }
    context 'with valid params' do
      let(:new_done_attribute) { { done: true } }
      it 'updates the requested task' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        put :update, params: { id: task.id, task: new_done_attribute }
        task.reload
        expect(task.done).to eq new_done_attribute[:done]
      end
      it 'renders a JSON response with the task' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        patch :update, params: { id: task.to_param, task: valid_attributes_for_update }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the task' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        patch :update, params: { id: task.to_param, task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:task) { create(:task, user: user) }
    it 'destroys the requested task' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end
  end
end

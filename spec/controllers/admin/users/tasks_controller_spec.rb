require 'rails_helper'

RSpec.describe Admin::Users::TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:manager) { create(:user, role: :manager) }
  let(:admin) { create(:user, role: :admin) }
  let!(:task) { create(:task, user: user) }

  describe 'GET #index' do
    it 'allows admin to receive tasks list' do
      sign_in_as(admin)
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status(200)
      expect(response_json.size).to eq 1
      expect(response_json.first['id']).to eq task.id
    end

    it 'allows manager to receive users list' do
      sign_in_as(manager)
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status(200)
      expect(response_json.size).to eq 1
      expect(response_json.first['id']).to eq task.id
    end

    it 'does not allow regular user to receive users list' do
      sign_in_as(user)
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status(401)
    end
  end
end

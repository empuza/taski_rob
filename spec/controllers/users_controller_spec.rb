require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in_as(user) }

  describe 'GET #me' do
    let!(:task) { create(:task, user: user) }

    it 'returns a success response' do
      get :me
      expect(response).to have_http_status(:success)
      expect(response_json).to eq user.as_json(only: %i[id username email])
    end
  end

end

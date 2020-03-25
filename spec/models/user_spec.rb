require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }

    context 'of uniqueness' do
      let!(:first_user) { create(:user) }
      it { should validate_uniqueness_of(:email) }
    end
  end

  describe 'association' do
    it { should have_many(:tasks).dependent(:destroy) }
  end
end

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:deadline) }
  end

  describe 'association' do
    it { should belong_to(:user) }
  end
end

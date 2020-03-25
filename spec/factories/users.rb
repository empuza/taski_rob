FactoryBot.define do
  factory :user do
    username { 'Test User' }
    email { Faker::Internet.email }
    password_digest { 'test' }
  end
end

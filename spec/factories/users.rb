FactoryBot.define do
  factory :user do
    username { 'Test User' }
    email { Faker::Internet.email }
    password { 'password' }
    activated { true }
  end
end

FactoryBot.define do
  factory :user do
    username { 'Test User' }
    email { Faker::Internet.email }
    password { 'password' }
  end
end

FactoryBot.define do
  factory :user do
    username { 'Test User' }
    email { Faker::Internet.email }
    password { 'password' }
    factory :activated_user, class: User do
      activated { true }
    end

    factory :not_activated_user_with_valid_token, class: User do
      activated { false }
      activation_token_expires_at { Time.now + 1.day }
    end

    factory :not_activated_user_with_expired_token, class: User do
      activated { false }
      activation_token_expires_at { Time.now - 1.day }
    end
  end
end

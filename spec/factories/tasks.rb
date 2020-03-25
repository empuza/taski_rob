FactoryBot.define do
  factory :task do
    name { "Task" }
    deadline { "2020-03-25 21:15:34" }
    done { false }
    user
  end
end

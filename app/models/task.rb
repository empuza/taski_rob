class Task < ApplicationRecord
  belongs_to :user

  validates :name, :deadline, presence: true
end

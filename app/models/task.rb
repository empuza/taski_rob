class Task < ApplicationRecord
  belongs_to :user

  validates :name, :deadline, presence: true
  validates_inclusion_of :done, in: [true, false]

  def self.tasks_by_status(status)
    where(done: status)
  end
end

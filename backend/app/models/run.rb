class Run < ApplicationRecord
  belongs_to :user

  enum privacy: {
    only_me: 0,
    open: 1,
    friends: 2
  }

  validates :started_at, :ended_at, presence: true
end

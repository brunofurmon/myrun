class Follow < ApplicationRecord
  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }

  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  validates :follower_id, uniqueness: {
    scope: :followee_id,
    message: "already requested"
  }
end

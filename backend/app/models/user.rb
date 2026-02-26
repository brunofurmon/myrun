class User < ApplicationRecord
  has_many :runs, dependent: :destroy

  has_many :sent_follows,
           class_name: "Follow",
           foreign_key: :follower_id,
           dependent: :destroy
  
  has_many :received_follows,
           class_name: "Follow",
           foreign_key: :followee_id,
           dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end

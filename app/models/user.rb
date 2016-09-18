class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :lists, through: :memberships

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :initials, presence: true
end

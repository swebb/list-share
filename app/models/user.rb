class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :lists, through: :memberships
  has_many :items, through: :lists

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :initials, presence: true
end

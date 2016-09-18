class List < ApplicationRecord
  has_many :memberships

  validates :name, presence: true
  validates :memberships, presence: true
end

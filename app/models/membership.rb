class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :list

  validates :user, presence: true
  validates :list, presence: true
end

class Item < ApplicationRecord
  belongs_to :list
  belongs_to :user, optional: true

  validates :name, presence: true
  validates :priority, presence: true
end

class Item < ApplicationRecord
  belongs_to :list

  validates :name, presence: true
  validates :priority, presence: true
end

class List < ApplicationRecord
  has_many :memberships

  validates :name, presence: true
  validates :memberships, presence: true

  def self.create_for(user, with: )
    List.new(with).tap do |list|
      list.memberships.build user: user
      list.save
    end
  end
end

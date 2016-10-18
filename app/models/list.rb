class List < ApplicationRecord
  has_many :memberships
  has_many :items, dependent: :destroy

  validates :name, presence: true
  validates :memberships, presence: true

  def self.create_for(user, with: )
    List.new(with).tap do |list|
      list.memberships.build user: user
      list.save
    end
  end

  def add_user(user)
    memberships.create user: user
  end

  def remove_user(user)
    memberships.find_by_user_id(user.id).destroy && (Membership.exists?(list_id: id) || destroy)
  end
end

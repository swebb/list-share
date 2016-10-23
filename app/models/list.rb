class List < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships
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
    remove_membership(user) &&
      unassign_user(user) &&
      remove_empty_list
  end

  private

  def remove_membership(user)
    memberships.find_by_user_id(user.id).destroy
  end

  def unassign_user(user)
    items.where(user_id: user.id).each do |item|
      item.update_attributes user: nil
    end
  end

  def remove_empty_list
    Membership.exists?(list_id: id) || destroy
  end
end

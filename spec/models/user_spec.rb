require 'rails_helper'

RSpec.describe User do
  describe '@email' do
    it { is_expected.to validate_presence_of(:email) }
    specify { expect(User.new(email: "me@home.com", name: "Me", initials: "M")).to validate_uniqueness_of(:email) }
  end

  describe '@name' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '@initials' do
    it { is_expected.to validate_presence_of(:initials) }
  end

  describe '@memberships' do
    it { is_expected.to have_many(:memberships) }
  end

  describe '@lists' do
    it { is_expected.to have_many(:lists).through(:memberships) }
  end

  describe '@items' do
    it { is_expected.to have_many(:items).through(:lists) }
  end
end

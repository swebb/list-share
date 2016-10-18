require "rails_helper"

RSpec.describe List do
  subject(:list) { described_class.new }

  describe "@name" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "@memberships" do
    it { is_expected.to have_many(:memberships) }
    it "must always belong to at least one user" do
      expect(list).to validate_presence_of(:memberships)
    end
  end

  describe "@items" do
    it { is_expected.to have_many(:items).dependent(:destroy) }
  end

  describe "#create_for" do
    subject(:list) { List.create_for user, with: params }

    let(:user) { FactoryGirl.create :user }
    let(:params) { {name: "Groceries" } }

    it { is_expected.to be_persisted }
    it { is_expected.to have_attributes params }
    specify { expect(list.memberships.count).to eq 1 }
    specify { expect(list.memberships.first.user).to eq user }
  end

  describe "#add_user" do
    subject(:add_user) { list.add_user user }

    let(:list) { FactoryGirl.create :list }
    let(:user) { FactoryGirl.create :user }

    before { add_user }

    specify { expect(user.lists).to include list }
  end
end

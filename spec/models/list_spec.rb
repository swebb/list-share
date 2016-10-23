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

  describe "@users" do
    it { is_expected.to have_many(:users).through(:memberships) }
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

  describe "remove_user" do
    subject(:remove_user) { list.remove_user user }

    let(:list) { FactoryGirl.create :list }
    let(:membership) { list.memberships.first }
    let(:user) { membership.user }

    context "list has only 1 user " do
      it "removes the membership and list" do
        remove_user
        expect(Membership.exists?(membership.id)).to eq false
        expect(List.exists?(list.id)).to eq false
      end
    end

    context "list has multiple users" do
      before { FactoryGirl.create :membership, list: list }

      it "only removes the membership" do
        remove_user
        expect(Membership.exists?(membership.id)).to eq false
        expect(List.exists?(list.id)).to eq true
      end

      context "user is assigned to an item" do
        let!(:item) { Item.create name: "Apples", list: list, user: user }

        it "removes the user from the item" do
          remove_user
          expect(item.reload.user).to eq nil
        end
      end
    end
  end
end

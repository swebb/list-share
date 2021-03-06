require 'rails_helper'

RSpec.describe Item do
  subject(:item) { described_class.new }

  describe "@list" do
    it { is_expected.to belong_to(:list) }
    it { is_expected.to validate_presence_of(:list).with_message("must exist") }
  end

  describe "@user" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to_not validate_presence_of(:user) }

    describe "foreign keys" do
      it "cannot be assigned to a user who is not a member of the list" do
        item = FactoryGirl.create :item
        item.user = FactoryGirl.create :user
        expect { item.save }.to raise_error ActiveRecord::InvalidForeignKey
      end

      it "cannot remove a user from a list if the user has assigned items" do
        list = FactoryGirl.create :list
        user = FactoryGirl.create :user
        membership = Membership.create user: user, list: list
        item = FactoryGirl.create :item, list: list, user: user
        expect { membership.destroy }.to raise_error ActiveRecord::InvalidForeignKey
      end
    end
  end

  describe "@name" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "@priority" do
    it "defaults to 0" do
      expect(item.priority).to eq 0
    end
    it { is_expected.to validate_presence_of(:priority) }
  end
end

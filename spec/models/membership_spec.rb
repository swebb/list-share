require "rails_helper"

RSpec.describe Membership do
  describe "@user" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe "@list" do
    it { is_expected.to belong_to(:list) }
    it { is_expected.to validate_presence_of(:list) }

    it "ensures a user can only be a member of each list once" do
      membership = FactoryGirl.create(:membership).dup
      expect(membership).to_not be_valid
      expect(membership.errors[:list]).to include "has already been taken"
    end
  end
end

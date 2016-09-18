require 'rails_helper'

RSpec.describe List do
  subject(:list) { described_class.new }

  describe '@name' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '@memberships' do
    it { is_expected.to have_many(:memberships) }
    it "must always belong to at least one user" do
      expect(list).to validate_presence_of(:memberships)
    end
  end
end

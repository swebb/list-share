require 'rails_helper'

RSpec.describe Item do
  subject(:item) { described_class.new }

  describe "@list" do
    it { is_expected.to belong_to(:list) }
    it { is_expected.to validate_presence_of(:list).with_message("must exist") }
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


require 'rails_helper'

RSpec.describe Membership do
  describe '@user' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe '@list' do
    it { is_expected.to belong_to(:list) }
    it { is_expected.to validate_presence_of(:list) }
  end
end

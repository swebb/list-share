FactoryGirl.define do
  factory :list do
    name { FFaker::Lorem.word }

    after(:build) do |list|
      if list.memberships.blank?
        list.memberships.build user: FactoryGirl.build(:user)
      end
    end
  end
end

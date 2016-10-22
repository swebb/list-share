FactoryGirl.define do
  factory :item do
    list
    name { FFaker::Lorem.word }
  end
end

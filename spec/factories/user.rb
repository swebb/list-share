FactoryGirl.define do
  factory :user do
    name { FFaker::Name.name }
    initials { |user| name.split(/ /).map(&:first).join }
    email { |user| user.name.downcase.gsub(/ /, ".") + "@example.com" }
  end
end

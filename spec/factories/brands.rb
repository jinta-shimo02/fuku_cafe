FactoryBot.define do
  factory :brand do
    sequence(:name) { |n| "name_#{n}" }
  end
end

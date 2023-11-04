FactoryBot.define do
  factory :review do
    rating { 5 }
    sequence(:content) { |n| "content_#{n}" }
    association :user
    association :shop
  end
end

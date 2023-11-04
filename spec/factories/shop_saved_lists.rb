FactoryBot.define do
  factory :shop_saved_list do
    sequence(:name) { |n| "list_#{n}" }
    association :user
  end
end

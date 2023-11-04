FactoryBot.define do
  factory :list_shop do
    association :shop_saved_list
    association :shop
  end
end

FactoryBot.define do
  factory :shop_brand do
    association :shop
    association :brand
  end
end

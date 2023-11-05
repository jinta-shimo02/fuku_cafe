FactoryBot.define do
  factory :shop_image do
    sequence(:image) { |n| "image_#{n}" }
    association :shop
  end
end

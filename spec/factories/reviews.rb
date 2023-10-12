FactoryBot.define do
  factory :review do
    rating { 1 }
    content { "MyText" }
    user { nil }
    shop { nil }
  end
end

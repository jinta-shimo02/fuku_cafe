FactoryBot.define do
  factory :shop do
    type { "Clothes" }
    sequence(:name) { |n| "name_#{n}" }
    sequence(:postal_code) { |n| "postal_code_#{n}" }
    sequence(:address) { |n| "address_#{n}" }
    sequence(:phone_number) { |n| "phone_number_#{n}" }
    sequence(:opening_hours) { |n| "opening_hours_#{n}" }
    sequence(:latitude) { |n| "latitude_#{n}" }
    sequence(:longitude) { |n| "longitude_#{n}" }
    sequence(:place_id) { |n| "place_id_#{n}" }
    sequence(:web_site) { |n| "web_site_#{n}" }
  end
end

class Brand < ApplicationRecord
  has_many :shop_brands
  has_many :shops, through: :shop_brands

  validates :name, presence: true
end

class Shop < ApplicationRecord
  has_many :shop_images, dependent: :destroy
  has_many :shop_brands
  has_many :brands, through: :shop_brands

  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :place_id, presence: true
end

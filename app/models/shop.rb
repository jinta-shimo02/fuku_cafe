class Shop < ApplicationRecord
  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  has_many :shop_images, dependent: :destroy
  has_many :shop_brands
  has_many :brands, through: :shop_brands
  has_many :list_shops, dependent: :destroy
  has_many :shop_saved_lists, through: :list_shops
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :place_id, presence: true

  def clothes?
    type == "Clothes"
  end

  def closest_shop(latitude, longitude)
    if type == 'Clothes'
      target_location = Geokit::LatLng.new(latitude, longitude)
      clothes_closest_shop = Clothes.where.not(id: self.id).closest(origin: target_location, units: :kms, within: 10).first
      clothes_closest_shop
    else
      target_location = Geokit::LatLng.new(latitude, longitude)
      cafe_closest_shop = Cafe.where.not(id: self.id).closest(origin: target_location, units: :kms, within: 10).first
      cafe_closest_shop
    end
  end
end

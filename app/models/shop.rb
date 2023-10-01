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

  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :place_id, presence: true

  def clothes?
    type == "Clothes"
  end
end

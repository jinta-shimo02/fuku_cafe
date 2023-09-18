class ShopSavedList < ApplicationRecord
  belongs_to :user
  has_many :list_shops, dependent: :destroy
  has_many :shops, through: :list_shops

  validates :name, presence: true, length: { maximum: 40 }
end

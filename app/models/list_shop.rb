class ListShop < ApplicationRecord
  belongs_to :shop_saved_list
  has_many :shops
end

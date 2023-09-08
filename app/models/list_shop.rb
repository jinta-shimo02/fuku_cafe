class ListShop < ApplicationRecord
  belongs_to :shop_saved_list
  belongs_to :shop
end

class ListShop < ApplicationRecord
  belongs_to :shop_saved_list
  belongs_to :shop

  validates :shop_saved_list_id, uniqueness: { scope: :shop_id }
end

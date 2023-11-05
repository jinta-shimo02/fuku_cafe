require 'rails_helper'

RSpec.describe ShopBrand, type: :model do
  describe '関連付けに関するテスト' do
    it '正しい関連付けが設定されていること' do
      shop = FactoryBot.create(:shop, type: 'Clothes')
      brand = FactoryBot.create(:brand)
      shop_brand = FactoryBot.create(:shop_brand, shop: shop, brand: brand)
      expect(shop_brand.shop).to eq shop
      expect(shop_brand.brand).to eq brand
    end
  end
end

require 'rails_helper'

RSpec.describe ListShop, type: :model do
  describe 'バリデーションに関するテスト' do
    it '１つのリストに同じショップは保存できないこと' do
      list_shop = FactoryBot.create(:list_shop)
      deplicate_list_shop = FactoryBot.build(:list_shop, shop_saved_list: list_shop.shop_saved_list, shop: list_shop.shop)
      expect(deplicate_list_shop).to be_invalid
    end
  end

  describe '関連付けに関するテスト' do
    it '正しい関連付けが設定されていること' do
      shop_saved_list = FactoryBot.create(:shop_saved_list)
      shop = FactoryBot.create(:shop)
      list_shop = FactoryBot.create(:list_shop, shop_saved_list: shop_saved_list, shop: shop)
      expect(list_shop.shop_saved_list).to eq shop_saved_list
      expect(list_shop.shop).to eq shop
    end
  end
end

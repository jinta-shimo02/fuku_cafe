require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe 'ショップのバリデーションに関するテスト' do
    it '店名、緯度、経度、place_idがある場合は有効' do
      valid_shop = FactoryBot.build(:shop)
      expect(valid_shop).to be_valid
    end

    it '店名がない場合は無効' do
      shop_without_name = FactoryBot.build(:shop, name: '')
      expect(shop_without_name).to be_invalid
    end

    it '緯度がない場合は無効' do
      shop_without_latitude = FactoryBot.build(:shop, latitude: '')
      expect(shop_without_latitude).to be_invalid
    end

    it '経度がない場合は無効' do
      shop_without_longitude = FactoryBot.build(:shop, longitude: '')
      expect(shop_without_longitude).to be_invalid
    end

    it 'place_idがない場合は無効' do
      shop_without_place_id = FactoryBot.build(:shop, place_id: '')
      expect(shop_without_place_id).to be_invalid
    end
  end

  describe 'ショップの関連付けに関するテスト' do
    before do
      @shop = FactoryBot.create(:shop)
    end

    it 'shop_imagesとの関連付けが正しく設定されていること' do
      shop_image = FactoryBot.create(:shop_image, shop: @shop)
      expect(@shop.shop_images).to include shop_image
    end

    it 'shop_brandsとbrandsの関連付けが正しく設定されていること' do
      brand = FactoryBot.create(:brand)
      @shop.brands << brand
      expect(@shop.brands).to include brand
    end

    it 'list_shopsとshop_saved_listの関連付けが正しく設定されていること' do
      shop_saved_list = FactoryBot.create(:shop_saved_list)
      @shop.shop_saved_lists << shop_saved_list
      expect(@shop.shop_saved_lists).to include shop_saved_list
    end

    it 'reviewsとの関連付けが正しく設定されていること' do
      review = FactoryBot.create(:review, shop: @shop)
      expect(@shop.reviews).to include review
    end
  end
end
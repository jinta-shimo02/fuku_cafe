require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe 'バリデーションに関するテスト' do
    it '名前がある場合は有効' do
      brand = FactoryBot.build(:brand)
      expect(brand).to be_valid
    end

    it '名前がない場合は無効' do
      brand = FactoryBot.build(:brand, name: '')
      expect(brand).to be_invalid
    end
  end

  describe '関連付けに関するテスト' do
    it '正しい逆の関連付けが設定されていること' do
      shop = FactoryBot.create(:shop)
      brand = FactoryBot.create(:brand)
      brand.shops << shop
      expect(brand.shops).to include shop
    end
  end
end

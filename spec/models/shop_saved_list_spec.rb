require 'rails_helper'

RSpec.describe ShopSavedList, type: :model do
  let(:user) { FactoryBot.create(:user) }
  describe 'バリデーションに関するテスト' do
    it 'リスト名がある場合は有効' do
      shop_saved_list = FactoryBot.build(:shop_saved_list, user: user)
      expect(shop_saved_list).to be_valid
    end

    it 'リスト名がない場合は無効' do
      shop_saved_list_without_name = FactoryBot.build(:shop_saved_list, name: '', user: user)
      expect(shop_saved_list_without_name).to be_invalid
    end

    it 'リスト名が40文字を超える場合は無効' do
      shop_saved_list_more_than_name = FactoryBot.build(:shop_saved_list, name: 'a' * 41, user: user)
      expect(shop_saved_list_more_than_name).to be_invalid
    end
  end

  describe '関連付けに関するテスト' do
    it 'list_shopsとの関連付けが正しく設定されていること' do
      shop_saved_list = FactoryBot.create(:shop_saved_list, user: user)
      shop = FactoryBot.create(:shop)
      shop_saved_list.shops << shop
      expect(shop_saved_list.shops).to include shop
    end
  end
end

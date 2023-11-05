require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'バリデーションに関するテスト' do
    it '評価、内容がある場合は有効' do
      review = FactoryBot.build(:review)
      expect(review).to be_valid
    end

    it '内容がない場合は無効' do
      review_without_content = FactoryBot.build(:review, content: '')
      expect(review_without_content).to be_invalid
    end

    it '内容が155文字を超える場合は無効' do
      character_over_review = FactoryBot.build(:review, content: 'a' * 156)
      expect(character_over_review).to be_invalid
    end
  end

  describe '関連付けに関するテスト' do
    it '正しい関連付けが設定されていること' do
      user = FactoryBot.create(:user)
      shop = FactoryBot.create(:shop)
      review = FactoryBot.create(:review, user: user, shop: shop)
      expect(review.user).to eq user
      expect(review.shop).to eq shop
    end
  end
end

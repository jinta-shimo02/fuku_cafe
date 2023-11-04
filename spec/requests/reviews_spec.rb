require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:user) { create(:user) }
  let(:shop) { create(:shop) }
  let(:review_1) { create(:review) }
  let(:review_2) { build(:review) }

  describe "GET /shops/:shop_id/reviews/new" do
    it 'レビュー作成画面の表示に成功すること' do
      login(user)
      get new_shop_review_path(shop)
      expect(response).to have_http_status(:success)
    end

    it 'ログインしていないとレビュー作成画面の表示に失敗すること' do
      get new_shop_review_path(shop)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'POST /shops/:shop_id/reviews' do
    before do
      login(user)
    end

    it 'レビュー作成処理が正常に実行されること' do
      expect {
        post shop_reviews_path(shop), params: { review: { rating: review_2.rating, content: review_2.content } }
      }.to change(Review, :count).by(1)
      expect(response).to have_http_status(:success)
      expect(response.body).to include 'レビューを投稿しました'
    end

    it 'レビューの内容が空欄の場合は作成処理に失敗すること' do
      post shop_reviews_path(shop), params: { review: { rating: review_2.rating, content: '' } }
      expect(response.body).to include '内容を入力してください'
    end
  end

  describe 'GET /reviews/:id/edit' do
    it 'レビュー編集画面の表示に成功すること' do
      login(user)
      get edit_review_path(review_1)
      expect(response).to have_http_status(:success)
    end

    it 'ログインしていないとレビュー編集画面の表示に失敗すること' do
      get edit_review_path(review_1)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PATCH /reviews/:id' do
    before do
      login(user)      
    end
    it 'レビューの更新処理が正常に実行されること' do
      patch review_path(review_1), params: { review: { rating: review_1.rating, content: '内容' } }
      expect(response).to have_http_status(:success)
      expect(response.body).to include 'レビューを更新しました'
    end

    it 'レビューの内容が空欄の場合はレビューの更新処理が失敗すること' do
      patch review_path(review_1), params: { review: { rating: review_1.rating, content: '' } }
      expect(response.body).to include '内容を入力してください'      
    end
  end

  describe 'DELETE /reviews/:id' do
    it 'レビューの削除処理が正常に実行されること' do
      login(user)
      delete review_path(review_1)
      expect(response).to have_http_status(:success)
      expect(response.body).to include 'レビューを削除しました'
    end
  end

  describe 'GET /shops/:shop_id/reviews/more' do
    it 'レビューの一覧の表示に成功すること' do
      login(user)
      get more_shop_reviews_path(shop)
      expect(response).to have_http_status(:success)
    end
  end
end

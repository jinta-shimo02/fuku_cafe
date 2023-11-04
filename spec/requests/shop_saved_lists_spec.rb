require 'rails_helper'

RSpec.describe "ShopSavedLists", type: :request do
  let(:user) { create(:user) }
  let(:shop_saved_list_1) { create(:shop_saved_list, user: user ) }
  let(:shop_saved_list_2) { build(:shop_saved_list, user: user) }

  describe "GET /shop_saved_lists" do
    it 'リスト一覧画面の表示に成功すること' do
      login(user)
      get shop_saved_lists_path
      expect(response).to have_http_status(:success)
    end

    it 'ログインしていないとリスト一覧画面の表示に失敗すること' do
      get shop_saved_lists_path
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'POST /shop_saved_lists' do
    it 'リスト登録処理が正常に実行されること' do
      login(user)
      expect {
        post shop_saved_lists_path, params: { shop_saved_list: { name: shop_saved_list_2.name, user: user } }
      }.to change(ShopSavedList, :count).by(1)
      expect(response).to redirect_to shop_saved_lists_path
    end
  end

  describe 'GET /shop_saved_list/:id' do
    it 'リスト詳細画面の表示に成功すること' do
      login(user)
      get shop_saved_list_path(shop_saved_list_1)
      expect(response).to have_http_status(:success)
    end

    it 'ログインしていないとリスト詳細画面の表示に失敗すること' do
      get shop_saved_list_path(shop_saved_list_1)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'GET /shop_saved_list/:id/edit' do
    it 'リスト編集画面の表示に成功すること' do
      login(user)
      get edit_shop_saved_list_path(shop_saved_list_1)
      expect(response).to have_http_status(:success)      
    end

    it 'ログインしていないとリスト編集画面の表示に失敗すること' do
      get edit_shop_saved_list_path(shop_saved_list_1)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PATCH /shop_saved_list/:id' do
    it 'リスト更新処理が正常に実行されること' do
      login(user)
      patch shop_saved_list_path(shop_saved_list_1), params: { shop_saved_list: { name: 'リスト', user: user } }
      expect(response).to have_http_status(:success)
    end

    it 'リストが空欄の場合は更新処理に失敗すること' do
      login(user)
      patch shop_saved_list_path(shop_saved_list_1), params: { shop_saved_list: { name: '', user: user } }
      expect(response.body).to include 'リスト名を入力してください'
    end
  end

  describe 'DELETE /shop_saved_list/:id' do
    it 'リスト削除処理が正常に実行されること' do
      login(user)
      delete shop_saved_list_path(shop_saved_list_1)
      expect(response).to redirect_to my_page_path
    end
  end
end

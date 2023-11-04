require 'rails_helper'

RSpec.describe "ListShops", type: :request do
  let(:user) { create(:user) }
  let(:shop) { create(:shop) }
  let(:shop_saved_list) { create(:shop_saved_list, user: user) }
  let(:list_shop) { create(:list_shop, shop_saved_list: shop_saved_list, shop: shop ) }
  
  before do
    login(user)
  end

  describe "POST /shops/:shop_id/list_shops" do
    it 'リスト保存処理が正常に実行されること' do
      expect {
        post shop_list_shops_path(shop, list_id: shop_saved_list.id)
      }.to change(ListShop, :count).by(1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /shops/:shop_id/list_shops/:id' do
    it 'リストとショップの関連削除処理が正常に実行されること' do
      delete shop_list_shop_path(shop, shop_saved_list)
      expect(response).to redirect_to  shop_saved_list_path(shop_saved_list)
    end
  end
end

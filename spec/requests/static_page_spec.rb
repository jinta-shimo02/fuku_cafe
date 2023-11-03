require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'GET /root' do
    it 'トップページが正常に表示されること' do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /terms' do
    it '利用規約のページが正常に表示されること' do
      get terms_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /privacy_policy' do
    it 'プライバシーポリシーのページが正常に表示されること' do
      get privacy_policy_path
      expect(response).to have_http_status(200)
    end
  end
end

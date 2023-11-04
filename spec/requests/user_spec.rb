require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users/sign_up' do
    it 'ユーザー新規登録画面の表示に成功すること' do
      get  new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /users' do
    let(:user) { build(:user) }
  
    it '正しい入力でユーザー新規登録に成功すること' do
      expect {
        post user_registration_path params: { user: { name: user.name, email: user.email, password: user.password, password_confirmation: user.password} }
      }.to change(User, :count).by(1)
      expect(response).to redirect_to home_path
    end

    it 'すでに存在しているメールアドレスでは登録に失敗すること' do
      user.save
      post user_registration_path params: { user: { name: user.name, email: user.email, password: user.password, password_confirmation: user.password } }
      expect(response.body).to include 'メールアドレスはすでに存在します'
    end

    it 'パスワードとパスワード（確認用）が一致しないときに登録が失敗すること' do
      post user_registration_path params: { user: { name: user.name, email: user.email, password: user.password, password_confirmation: 'different_password' } }
      expect(response.body).to include 'パスワード（確認用）とパスワードの入力が一致しません'
    end
  end
end

require 'rails_helper'

RSpec.describe 'UserSessions', type: :request do
  let(:user) { create(:user) }

  describe 'GET /users/sign_in' do
    it 'ユーザーのログイン画面の表示に成功すること' do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /users/sign_in' do
    it '正しい入力でユーザーのログインに成功すること' do
      post user_session_path params: { user: { email: user.email, password: user.password } }
      expect(response).to have_http_status(303)
      expect(response).to redirect_to home_path
    end

    it '違うメールアドレスを入力したときにログインに失敗すること' do
      post user_session_path params: { user: { email: 'a@wrong.com', password: user.password } }
      expect(response).to have_http_status(422)
      expect(response.body).to include 'メールアドレスまたはパスワードが違います。'
    end

    it '違うパスワードを入力したときにログインに失敗すること' do
      post user_session_path params: { user: { email: user.email, password: 'different_password' } }
      expect(response).to have_http_status(422)
      expect(response.body).to include 'メールアドレスまたはパスワードが違います。'
    end
  end

  describe 'DELETE /sign_out' do
    it '正常にログアウトができること' do
      post user_session_path params: { user: { email: user.email, password: user.password } }
      delete destroy_user_session_path
      expect(response).to have_http_status(303)
      expect(response).to redirect_to root_path
    end
  end
end

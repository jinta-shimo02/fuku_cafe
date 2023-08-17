require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン' do

    describe 'ログイン前' do
      context 'フォームの入力が正常' do
        it 'ログイン成功' do
          visit new_user_session_path
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
          click_button 'ログイン'
          expect(page).to have_content 'ログインしました。'
          expect(current_path).to eq root_path
        end
      end 
      
      context 'フォームが未入力' do
        it 'ログイン失敗' do
          visit new_user_session_path
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: ''
          click_button 'ログイン'
          expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
          expect(current_path).to eq new_user_session_path
        end
      end
    end

    describe 'ログイン後' do
      context 'ログアウトをクリック' do
        it 'ログアウト成功' do
          login_as(user)
          click_link 'ログアウト'
          expect(page).to have_content 'ログアウトしました。'
          expect(current_path).to eq root_path
        end
      end
    end
  end
end
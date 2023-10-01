require 'rails_helper'

RSpec.describe "UserRegistrations", type: :system do
  let(:user) { create(:user) }

  describe '新規登録' do
    before do
      visit new_user_registration_path
    end

    context 'フォームの入力が正常' do
      it '正常に登録される' do
        fill_in 'user[name]', with: 'user'
        fill_in 'user[email]', with: 'email@example.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button 'アカウント登録'
        expect(page).to have_content 'アカウント登録が完了しました'
        expect(current_path).to eq root_path
      end
    end

    context '名前が未入力' do
      it '登録失敗' do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: 'email@example.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button 'アカウント登録'
        expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
        expect(page).to have_content '名前を入力してください'
        expect(current_path).to eq new_user_registration_path
      end
    end

    context 'メールアドレスが未入力' do
      it '登録失敗' do
        fill_in 'user[name]', with: 'user'
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button 'アカウント登録'
        expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content 'メールアドレスは不正な値です'
        expect(current_path).to eq new_user_registration_path
      end
    end

    context 'メールアドレスが不正な値' do
      it '登録失敗' do
        fill_in 'user[name]', with: 'user'
        fill_in 'user[email]', with: 'a@a'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button 'アカウント登録'
        expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
        expect(page).to have_content 'メールアドレスは不正な値です'
        expect(current_path).to eq new_user_registration_path
      end
    end

    context 'すでに登録されているメーアドレスを使用' do
      it '登録失敗' do
        other_user = create(:user)
        fill_in 'user[name]', with: 'user'
        fill_in 'user[email]', with: other_user.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button 'アカウント登録'
        expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
        expect(page).to have_content 'メールアドレスはすでに存在します'
        expect(current_path).to eq new_user_registration_path
      end
    end

    context 'パスワード及びパスワード確認が6文字以下' do
      it '登録失敗' do
        fill_in 'user[name]', with: 'user'
        fill_in 'user[email]', with: 'email@example.com'
        fill_in 'user[password]', with: 'aaaaa'
        fill_in 'user[password_confirmation]', with: 'aaaaa'
        click_button 'アカウント登録'
        expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(current_path).to eq new_user_registration_path
      end
    end

    context 'パスワード及びパスワード確認が未入力' do
      it '登録失敗' do
        fill_in 'user[name]', with: 'user'
        fill_in 'user[email]', with: 'email@example.com'
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button 'アカウント登録'
        expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(page).to have_content 'パスワード（確認用）を入力してください'
        expect(current_path).to eq new_user_registration_path
      end
    end
  end
end

module LoginMacros
  def login_as(user)
    visit new_user_session_path
    click_link 'ログイン'
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'password'
    click_button 'ログイン'
  end
end
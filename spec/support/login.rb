module Login
  def login(user)
    get new_user_session_path
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end
end
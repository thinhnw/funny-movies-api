def get_login_token(user)
  post '/login', params: { user: { email: user.email, password: user.password } }
  response.headers['Authorization']
end

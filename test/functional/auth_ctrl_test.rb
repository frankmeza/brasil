require_relative '../test_helper.rb'

class RackTest

  def setup
    @user = create(:user)
  end

  def teardown
    clean_data
  end

  def test_post_login_authenticate
    credentials = { login: @user.username, password: 'password' }
    post '/login/auth', credentials.to_json
    payload = JSON.parse last_response.body

    assert last_response.ok?
    token = JWT.encode credentials[:login], credentials[:password], 'HS256'
    assert_equal token, payload['token']
  end
end

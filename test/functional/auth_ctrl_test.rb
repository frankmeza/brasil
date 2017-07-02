require_relative '../test_helper.rb'

class RackTest

  def setup
    @user = create(:user)
  end

  def teardown
    clean_data
  end

  # POST '/auth/login'
  def test_login_authenticate_success
    credentials = { login: @user.username, password: 'password' }
    post '/auth/login', credentials.to_json
    payload = JSON.parse last_response.body
    expected_token = JWT.encode credentials[:login], credentials[:password], 'HS256'

    assert last_response.ok?
    assert_equal expected_token, payload['token']
  end

  def test_login_authenticate_fail
    bad_credentials = { login: @user.username, password: 'wrongpassword' }
    post '/auth/login', bad_credentials.to_json
    errors = { errors: 'Your login credentials are not correct.' }

    assert_equal 401, last_response.status
    assert_equal errors.to_json, last_response.body
  end

  # GET '/auth/logout'
  def test_logout
    login_this @user

    get 'auth/logout'
    assert last_response.ok?
    logged_out = { logged_out: true }
    assert_equal logged_out.to_json, last_response.body
  end
end

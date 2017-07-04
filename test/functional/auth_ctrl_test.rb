require_relative '../test_helper.rb'

class RackTest

  def setup
    @user = create(:user)
    # how to set request headers
    # @correct_headers = AuthCtrl.encode_data(@user.get_data)
    # header('HTTP_JWT_TOKEN', @correct_headers)
    # how to read response headers
    # res.headers['MYHEADER']
  end

  def teardown
    clean_data
  end

  # POST '/auth/login'
  def test_login_success
    credentials = { login: @user.username, password: 'password' }
    post '/auth/login', credentials.to_json
    assert_equal 201, res.status

    payload = JSON.parse(res.body)
    user = User.fetch(credentials[:login])
    expected_token = AuthCtrl.encode_data(user.get_data)
    assert_equal expected_token, payload['token']
  end

  def test_login_fail
    bad_credentials = { login: @user.username, password: 'wrongpassword' }
    post '/auth/login', bad_credentials.to_json
    assert_equal 401, res.status

    errors = Message.get_msg('credentials_invalid')
    assert_equal errors.to_json, res.body
  end

  # GET '/auth/logout'
  def test_logout
    login_this @user

    get 'auth/logout'
    assert_equal 200, res.status

    logged_out = { logged_out: true }
    assert_equal logged_out.to_json, res.body
  end
end

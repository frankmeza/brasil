require_relative '../test_helper.rb'

class AuthCtrlTest < RackTest

  def setup
    @user = create(:user)
  end

  def teardown
    clean_data
  end

  # POST '/auth/login'
  def test_login_success
    credentials = { login: @user.username, password: 'password' }
    post '/auth/login', credentials.to_json
    assert_equal(201, res.status)
    user = User.fetch(credentials[:login])
    expected_token = AuthCtrl.encode_data(user.data_for_token)
    assert_equal(expected_token, res_as_json['token'])
  end

  def test_login_fail
    bad_credentials = { login: @user.username, password: 'wrongpassword' }
    post '/auth/login', bad_credentials.to_json
    assert_equal(401, res.status)
    errors = Message.get_msg('credentials_invalid')
    assert_equal(errors.to_json, res.body)
  end

  # GET '/auth/logout'
  def test_logout
    login_this(@user)
    get 'auth/logout'
    assert_equal(200, res.status)
    logged_out = { logged_out: true }
    assert_equal(logged_out.to_json, res.body)
  end
end

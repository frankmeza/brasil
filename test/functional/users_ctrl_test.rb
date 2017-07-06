require_relative '../test_helper.rb'

class RackTest

  def setup
    @user = create(:user)
    @admin = create(:user, :admin)
    @users = create_list(:user, 2)
  end

  def teardown
    clean_data
  end

  def test_users_root_admin_success
    admin_token = AuthCtrl.encode_data(@admin.get_data)
    get '/users', {}, {"HTTP_JWT_TOKEN" => admin_token}

    assert_equal(200, res.status)
    # the +2 accounts for @user and @admin
    assert_equal(@users.size + 2, res_as_json['users'].size)
  end

  def test_users_root_user_fail
    user_token = AuthCtrl.encode_data(@user.get_data)
    get '/users', {}, {"HTTP_JWT_TOKEN" => user_token}

    assert_equal(403, res.status)
    assert_equal 'Your token is not an admin token.', res_as_json
  end
end

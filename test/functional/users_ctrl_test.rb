require_relative '../test_helper.rb'

class RackTest

  def setup
    @user = create(:user)
    @admin = create(:user, :admin)
    @users = create_list(:user, 2)
    admin_token = AuthCtrl.encode_data(@admin.get_data)
    @jwt_admin = {"HTTP_JWT_TOKEN" => admin_token}
  end

  def teardown
    clean_data
  end

  # GET /users
  def test_users_root_admin_success
    get '/users', {}, @jwt_admin
    assert_equal(200, res.status)
    # the +2 accounts for @user and @admin
    assert_equal(@users.size + 2, res_as_json['users'].size)
  end

  # GET /users
  def test_users_root_user_fail
    user_token = AuthCtrl.encode_data(@user.get_data)
    get '/users', {}, {"HTTP_JWT_TOKEN" => user_token}
    assert_equal(403, res.status)
    assert_equal('Your token is not an admin token.', res_as_json)
  end

  # GET /users/:username
  def test_user_show_by_username
    get "/users/#{@user.username}", {}, @jwt_admin
    assert_equal(200, res.status)
    assert_equal(@user.email, res_as_json['email'])
    assert_equal(@user.username, res_as_json['username'])
  end

  # GET /users/id/:id
  def test_user_show_by_id
    get "/users/id/#{@user.id}", {}, @jwt_admin
    assert_equal(200, res.status)
    assert_equal(@user.email, res_as_json['email'])
    assert_equal(@user.username, res_as_json['username'])
  end

  # def test_update_user
  #   new_username = { username: 'updated' }
  #   put "/users/#{@user.id}/edit", new_username, @jwt_admin
  #   assert_equal(204, res.status)
  #   assert_equal(@user.username, new_username[:username])
  # end
end

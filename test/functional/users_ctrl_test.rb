require_relative '../test_helper.rb'

class UserCtrlTest < RackTest

  def setup
    @user = create(:user)
    @admin = create(:user, :admin)
    @users = create_list(:user, 2)
    admin_token = AuthCtrl.encode_data(@admin.data_for_token)
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
    user_token = AuthCtrl.encode_data(@user.data_for_token)
    get '/users', {}, {"HTTP_JWT_TOKEN" => user_token}
    assert_equal(403, res.status)
    assert_equal('Your token is not an admin token.', res_as_json)
  end

  # GET /users/:username
  def test_user_show_by_username
    get "/users/username/#{@user.username}", {}, @jwt_admin
    assert_equal(200, res.status)
    assert_equal(@user.email, res_as_json['user']['email'])
    assert_equal(@user.username, res_as_json['user']['username'])
  end

  # GET /users/id/:id
  def test_user_show_by_id
    get "/users/id/#{@user.id}", {}, @jwt_admin
    assert_equal(200, res.status)
    assert_equal(@user.email, res_as_json['user']['email'])
    assert_equal(@user.username, res_as_json['user']['username'])
  end

  # PATCH /users/id/:id
  def test_update_user_success
    new_username = { username: 'updated' }
    patch "/users/id/#{@user.id}", new_username.to_json, @jwt_admin
    assert_equal(204, res.status)
  end

  def test_create_user_success
    new_user = attributes_for(:user)
    post "/users", new_user.to_json, @jwt_admin
    assert_equal(201, res.status)
  end

  def test_create_user_fail
    new_user = attributes_for(:user, username: 'f', email: '')
    post "/users", new_user.to_json, @jwt_admin
    assert_equal(422, res.status)
    assert_equal(Message.get_msg('bad_request'), res_as_json['errors'])
  end

  # DELETE /users/id/:id
  def test_delete_user
    delete "/users/id/#{@user.id}", {}, @jwt_admin
    assert_equal(204, res.status)
  end
end

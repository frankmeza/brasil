require_relative '../test_helper.rb'

class RackTest

  def setup
    @user = create(:user)
    token = AuthCtrl.encode_data(@user.get_data)
    @jwt_user_header = {"HTTP_JWT_TOKEN" => token}

    @admin = create(:user, :admin)
    token = AuthCtrl.encode_data(@admin.get_data)
    @jwt_admin_header = {"HTTP_JWT_TOKEN" => token}
  end

  def teardown
    clean_data
  end

  def test_get_users
    users = create_list(:user, 9)
    # get '/users', {}, @jwt_user_header
    get '/users', {}, @jwt_admin_header

    assert_equal(200, res.status)
    # the +1 accounts for the user created in setup
    assert_equal(users.size + 2, res_as_json['users'].size)
  end

  # def test_post_users
  #   post '/users/lit', {lit: "lit"}
  #   assert_equal 200, res.status
  # end
end

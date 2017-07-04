require_relative '../test_helper.rb'

class RackTest

  def setup
    @user = create(:user)
    token = AuthCtrl.encode_data(@user.get_data)
    @jwt_header = {"JWT_TOKEN" => token}
  end

  def teardown
    clean_data
  end

  def test_get_users
    users = create_list(:user, 10)
    get '/users', {}, @jwt_header
    assert_equal(200, res.status)
    # the +1 accounts for the user created in setup
    assert_equal(users.size + 1, res_as_json['users'].size)
  end

  # def test_post_users
  #   post '/users/lit', {lit: "lit"}
  #   assert_equal 200, res.status
  # end
end

require_relative '../test_helper.rb'

class RackTest

  def teardown
    clean_data
  end

  # def test_get_users
  #   frank = create(:user)
  #   get '/users'
  #   assert last_response.ok?
  # end

  def test_login_root
    post '/', {}
    puts last_response.errors
    assert last_response.ok?
    assert last_response.body == 'root it'
  end

  def test_post_login_authenticate
    post '/login/auth', {username: "username"}
    puts last_response.errors
    assert last_response.ok?
  end
end

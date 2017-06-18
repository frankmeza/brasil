require_relative '../test_helper.rb'

class RackTest

  def teardown
    clean_data
  end

  def test_get_users
    frank = create(:user)
    get '/users'
    assert last_response.ok?
  end

  def test_post_users
    post '/users/lit', {lit: "lit"}
    assert last_response.ok?
  end
end

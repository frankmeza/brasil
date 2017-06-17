require_relative '../test_helper.rb'

class RackTest

  def test_get_users_how
    get '/users/how'
    assert last_response.ok?
  end

  def test_post_users
    post '/users/lit', {lit: "lit"}
    assert last_response.ok?
  end
end

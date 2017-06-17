require_relative '../test_helper.rb'

class RackTest
  def test_root
    get '/'
    assert last_response.ok?
    assert_equal last_response.body, { lit: true }.to_json
  end

  def test_get_users
    get '/users'
    assert last_response.ok?
    assert_equal last_response.body, 'wow, so lit'
  end

  def test_get_users_how
    get '/users/how'
    assert last_response.ok?
    assert_equal last_response.body, 'wow, how'
  end

  def test_post_users
    post '/users/lit', {lit: "lit"}
    assert last_response.ok?
    puts last_response.body
  end
end
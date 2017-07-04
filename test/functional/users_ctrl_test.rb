require_relative '../test_helper.rb'

class RackTest

  def teardown
    clean_data
  end

  def test_get_users
    frank = create(:user)
    get '/users'
    assert_equal 200, res.status
  end

  # def test_post_users
  #   post '/users/lit', {lit: "lit"}
  #   assert_equal 200, res.status
  # end
end

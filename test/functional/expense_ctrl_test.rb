require_relative '../test_helper.rb'

class RackTest

  def setup
    @admin = create(:user, :admin)
    admin_token = AuthCtrl.encode_data(@admin.data_for_token)
    @jwt_admin = {"HTTP_JWT_TOKEN" => admin_token}
  end

  def teardown
    clean_data
  end

  # GET /expenses
  def test_expenses_root
    get '/expenses', {}, @jwt_admin
    assert_equal(200, res.status)
  end
end

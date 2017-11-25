require_relative '../test_helper.rb'

class RackTest

  def setup
    @admin = create(:user, :admin)
    @admin_token = AuthCtrl.encode_data(@admin.data_for_token)
    @jwt_admin = {"HTTP_JWT_TOKEN" => @admin_token}
  end

  def teardown
    clean_data
  end

  # GET /expenses
  def test_expenses_root
    expenses = create_list(:expense, 3)
    get '/expenses', {}, @jwt_admin
    assert_equal(200, res.status)
    assert_equal(expenses.size, res_as_json['expenses'].size)
  end

  # POST /expenses
  def test_expense_create
    expense_attributes = attributes_for(:expense)
    post '/expenses', expense_attributes.to_json, @jwt_admin
    assert_equal(201, res.status)
  end
end

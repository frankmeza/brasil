require_relative '../test_helper.rb'

class AppTest < RackTest
  def test_root
    get '/'
    assert_equal(200, res.status)

    expected = { root_path: true }.to_json
    assert_equal(expected, res.body)
  end
end

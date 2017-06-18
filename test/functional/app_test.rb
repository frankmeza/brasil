require_relative '../test_helper.rb'

class RackTest
  def test_root
    get '/'
    assert last_response.ok?
    assert_equal last_response.body, { lit: true }.to_json
  end
end

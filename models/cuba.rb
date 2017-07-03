# helpers

module Helpers
  def set_response_as_json
    res.headers['Content-Type'] = 'application/json'
  end
end

class Cuba
  include Helpers
end

require_relative '../lib/auth_jwt_helpers'
require_relative '../lib/response_helpers'
require_relative '../lib/request_helpers'

class Brasil < Cuba
  include AuthJwtHelpers
  include RequestHelpers
  include ResponseHelpers
end

require_relative '../lib/auth_jwt_helpers'
require_relative '../lib/response_helpers'

class Brasil < Cuba
  include AuthJwtHelpers
  include ResponseHelpers
end

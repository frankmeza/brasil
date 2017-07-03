# helpers

module Helpers
  def set_response_as_json
    res.headers['Content-Type'] = 'application/json'
  end

  def get_msg(key)
    puts ENV['MESSAGES'][key].to_s
  end
end

module AuthHelpers
  def has_jwt?
    req.headers['JWT_TOKEN'].present?
  end

  def encode_user_data(data)
    JWT.encode data, ENV['JWT_SECRET'], 'HS256'
  end

  def decode_jwt_token(token)
    JWT.decode token, ENV['JWT_SECRET'], true, { algorithm: 'HS256' }
  end

  def is_valid_token?(token)
    data = decode_jwt_token(token)
    user = User.fetch data['email']
    user.username == data['username']
  end
end

class Cuba
  include Helpers
  include AuthHelpers
end

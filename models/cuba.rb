# helpers

module ResponseHelpers
  def set_response_as_json
    res.headers['Content-Type'] = 'application/json'
  end

  def set_response_status(code)
    res.status = code
  end
end

module AuthHelpers
  def has_jwt?
    ENV['HTTP_JWT_TOKEN'].present?
  end

  def encode_data(data)
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
  include ResponseHelpers
  include AuthHelpers
end

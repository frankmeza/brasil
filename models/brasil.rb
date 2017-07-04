module ResponseHelpers
  def set_response_as_json
    res.headers['Content-Type'] = 'application/json'
  end

  def set_response_status(code)
    res.status = code
  end
end

module AuthJwtHelpers
  def has_jwt?
    env['HTTP_JWT_TOKEN'].present?
  end

  def encode_data(data)
    JWT.encode data, ENV['JWT_SECRET'], 'HS256'
  end

  def decode_jwt_token(token)
    JWT.decode token, ENV['JWT_SECRET'], true, { algorithm: 'HS256' }
  end

  def respond_with(status, message_key)
    ['401', {"Content-Type" => "application/json"}, [Message.get_msg(message_key).to_json]]
  end

  def is_valid_token?(token)
    data = decode_jwt_token(token)[0]
    user = User.fetch data['email']
    user.username == data['username']
  end
end

class Brasil < Cuba
  include AuthJwtHelpers
  include ResponseHelpers
end

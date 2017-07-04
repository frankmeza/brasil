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
    env['JWT_TOKEN'].present?
  end

  def encode_data(data)
    JWT.encode(data, $JWT_SECRET, 'HS256')
  end

  def decode_jwt_token(token)
    JWT.decode(token, $JWT_SECRET, true, { algorithm: 'HS256' })
  end

  def respond_with(status, message_key)
    as_json = {"Content-Type" => "application/json"}
    [status.to_s, as_json, [Message.get_msg(message_key).to_json]]
  end

  def is_valid_token?(token)
    data = decode_jwt_token(token)
    user = User.fetch(data[0]['email'])
    user.username == data[0]['username']
  end
end

class Brasil < Cuba
  include AuthJwtHelpers
  include ResponseHelpers
end

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
    JWT.encode(data, $JWT_SECRET, 'HS256')
  end

  def decode_jwt_token(token)
    JWT.decode(token, $JWT_SECRET, true, { algorithm: 'HS256' })
  end

  def respond_with(status, message_key)
    as_json = {"Content-Type" => "application/json"}
    [status.to_s, as_json, [Message.get_msg(message_key).to_json]]
  end

  def fetch_user_from_token(token)
    data = decode_jwt_token(token)
    user = User.fetch(data[0]['email'])
    { token: token, user: user }
  end

  def is_valid_token?(token)
    # fetched = fetch_user_from_token(token)
    data = decode_jwt_token(token)
    # fetched[:user]
    user = User.fetch(data[0]['email'])
    # up can be moved out
    user.username == data[0]['username']
  end

  def is_valid_admin_token?(token)
    # fetched = fetch_user_from_token(token)
    data = decode_jwt_token(token)
    # fetched[:user]
    user = User.fetch(data[0]['email'])
    # up can be moved out
    user.username == data[0]['username'] && user.is_admin
  end
end

class Brasil < Cuba
  include AuthJwtHelpers
  include ResponseHelpers
end

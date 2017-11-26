module AuthJwtHelpers
  def decode_jwt_token(token)
    JWT.decode(token, $JWT_SECRET, true, { algorithm: 'HS256' })
  end

  def encode_data(data)
    data[:exp] = Time.now.to_i + 28800 # 8 hours
    JWT.encode(data, $JWT_SECRET, 'HS256')
  end

  def has_jwt?
    env['HTTP_JWT_TOKEN'].present?
  end

  def is_valid_admin_token?(token)
    data = decode_jwt_token(token)
    user_id_from_token = data[0]['id']['$oid']
    user = User.[](user_id_from_token)
    user.id.to_s == user_id_from_token && user.is_admin
  end

  def is_valid_token?(token)
    data = decode_jwt_token(token)
    user_id_from_token = data[0]['id']['$oid']
    user = User.[](user_id_from_token)
    user.id.to_s == user_id_from_token
  end

  def respond_with(status, message_key, headers = {})
    headers ||= {"Content-Type" => "application/json"}
    [status.to_s, headers, [Message.get_msg(message_key).to_json]]
  end
end

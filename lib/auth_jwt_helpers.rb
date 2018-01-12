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
    is_valid_token?(token, true)
  end

  def is_valid_token?(token, check_admin = false)
    raw_data = decode_jwt_token(token)
    user_data = decoded_user_data(raw_data)
    user = User.[](user_data.id)
    check_admin ?
      user.id.to_s == user_data.id && user.is_admin :
      user.id.to_s == user_data.id
  end

  def respond_with(status, message_key, headers = {})
    headers ||= {'Content-Type' => 'application/json'}
    [status.to_s, headers, [Message.get_msg(message_key).to_json]]
  end

  # payload={'id': {'$oid'=>'5a1a028484584a50de000000'},
  #   'is_admin': true, 'exp'=>1515752153}
  # header={'alg': 'HS256'}
  def decoded_user_data(raw_data)
    Struct.new('DecodedData', :payload, :header)
    Struct.new('UserData', :id, :is_admin, :expires_at)
    data = Struct::DecodedData.new(raw_data[0], raw_data[1])
    user_data = Struct::UserData.new(
      data.payload['id']['$oid'],
      data.payload['is_admin'],
      data.payload['exp']
    )
    return user_data
  end
end

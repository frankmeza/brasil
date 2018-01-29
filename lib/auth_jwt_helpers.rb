module AuthJwtHelpers
  def decode_jwt_token(token)
    # data is [payload, header]
    data = JWT.decode(token, $JWT_SECRET, true, { algorithm: 'HS256' })
    decoded_data = create_decoded_data(data[0], data[1])
    decoded_data.header['alg'] == 'HS256' ? data : nil
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
    # user_data will be nil if token.header['alg'] != 'HS256'
    return false if raw_data == nil
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

  def create_decoded_data(payload, header)
    Struct.new('DecodedData', :payload, :header)
    return Struct::DecodedData.new(payload, header)
  end

  def create_user_data_struct(id, is_admin, expires_at)
    Struct.new('UserData', :id, :is_admin, :expires_at)
    return Struct::UserData.new(id, is_admin, expires_at)
  end

  # payload={'id': {'$oid'=>'5a1a028484584a50de000000'}, 'is_admin': true, 'exp'=>1515752153}
  # header={'alg': 'HS256'}
  def decoded_user_data(raw_data)
    data = create_decoded_data(raw_data[0], raw_data[1])

    user_data = create_user_data_struct(
      data.payload['id']['$oid'],
      data.payload['is_admin'],
      data.payload['exp']
    )

    return user_data
  end
end

AuthCtrl = Brasil.new do
  on post, 'login' do
    set_response_as_json
    body = parse_req_as_json

    if login(User, body['login'], body['password'])
      user = User.fetch(body['login'])
      token = encode_data(user.data_for_token)
      set_response_status(201)
      write_res_as_json(token: token)
    else
      halt respond_with(401, 'credentials_invalid')
    end
  end

  on get, 'logout' do
    logout(User)
    write_res_as_json(logged_out: true)
  end
end

Brasil.define do
  run AuthCtrl
end

# auth_controller

AuthCtrl = Cuba.new do
  on post, 'login' do
    input = req.body.read
    body = JSON.parse(input)

    if login User, body['login'], body['password']
      token = JWT.encode body['login'], body['password'], 'HS256'
      auth_token = { token: token }
    end

    res.write auth_token.to_json
  end

  on get, 'logout' do
    logout User
    logged_out = { logged_out: true }
    res.write logged_out.to_json
  end
end

Cuba.define do
  run AuthCtrl
end

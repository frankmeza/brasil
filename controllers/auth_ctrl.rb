# auth_controller

AuthCtrl = Cuba.new do
  on post, 'auth' do
    input = req.body.read
    body = JSON.parse(input)
    if login User, body['login'], body['password']
    # user = User.authenticate body['login'], body['password']
    res.write user.to_json
  end
end

Cuba.define do
  run AuthCtrl
end

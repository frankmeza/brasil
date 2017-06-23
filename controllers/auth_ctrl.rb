# auth_controller

AuthCtrl = Cuba.new do
  on post, 'auth' do
    a, b = req.params["a"], req.params["b"]
    user, pass = req.params['username'], req.params['password']
    rqb = req.body.read
    puts rqb.class
    res.write rqb
  end

  on post, root, param('ytho') do |ytho|
    res.write "#{ytho}"
  end
end

Cuba.define do
  run AuthCtrl
end
# end

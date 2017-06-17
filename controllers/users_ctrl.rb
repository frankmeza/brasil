# users_controller

UsersCtrl = Cuba.new do
  on get, root do
    res.write 'wow, so lit'
  end
end

Cuba.define do
  on root do
    run UsersCtrl
  end
end

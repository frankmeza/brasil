# users_controller

UsersCtrl = Brasil.new do
  on get, root do
    set_response_as_json
    users = User.all.map do |user|
      { id: user.id, username: user.username, email: user.email }
    end
    res.write users.to_json
  end

  on get, ':username' do |username|
    set_response_as_json
    u = User.fetch_by_username(username)
    # user = { id: u.id, username: u.username, email: u.email }
    user = u.serialize(:id, :username, :email)
    res.write user.to_json
  end

  on get, '/id/:id' do |id|
    set_response_as_json
    user = User.find(id)
    puts user
    puts User.all.size
    res.write user.to_json
  end

  on post, 'lit', param('lit') do |lit|
    res.write "#{lit}"
  end
end

Brasil.define do
  run UsersCtrl
end

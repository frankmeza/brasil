# users_controller

UsersCtrl = Brasil.new do
  on get, root do
    set_response_as_json
    emails = User.all.map(&:email)
    user_emails = { users: emails }
    res.write user_emails.to_json
  end

  on get, 'how' do
    res.write 'wow, how'
  end

  on post, 'lit', param('lit') do |lit|
    res.write "#{lit}"
  end
end

Brasil.define do
  run UsersCtrl
end

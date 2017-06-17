# users_controller

UsersCtrl = Cuba.new do
  on get, root do
    emails = User.all.map(&:email)
    res.write emails
  end

  on get, 'how' do
    res.write 'wow, how'
  end

  on post, 'lit', param('lit') do |lit|
    res.write "#{lit}"
  end
end

Cuba.define do
  run UsersCtrl
end

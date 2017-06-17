# users_controller

UsersCtrl = Cuba.new do
  on get, root do
    res.write 'wow, so lit'
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
